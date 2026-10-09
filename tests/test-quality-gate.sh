#!/bin/sh
# Behavioural tests for .claude/scripts/quality-gate. Run: sh tests/test-quality-gate.sh
set -u

export GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_NOSYSTEM=1

ENGINE="$(cd "$(dirname "$0")/.." && pwd)/.claude/scripts/quality-gate"
TAB=$(printf '\t')
PASSED=0
FAILED=0
SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT

new_repo() {
  repo="$SANDBOX/$1"
  mkdir -p "$repo/lib" "$repo/.claude/context"
  cd "$repo" || exit 1
  git init -q -b main
  git config user.email test@example.com
  git config user.name Test
  printf 'untouched = 1\n' > lib/untouched.txt
  printf 'clean = 1\n' > lib/touched.txt
  git add lib
  git commit -q -m "chore: seed"
  git checkout -q -b feature
}

write_config() {
  printf '%s\n' "$@" > .claude/context/quality-gate.conf
}

run_gate() {
  output=$(sh "$ENGINE" "$@" 2>&1)
  status=$?
}

expect() {
  description="$1"
  expected_status="$2"
  expected_text="$3"
  if [ "$status" -eq "$expected_status" ] && printf '%s' "$output" | grep -Fq -- "$expected_text"; then
    PASSED=$((PASSED + 1))
  else
    FAILED=$((FAILED + 1))
    printf 'FAIL: %s\n  want status %s containing "%s"\n  got status %s:\n%s\n' \
      "$description" "$expected_status" "$expected_text" "$status" "$output"
  fi
}

new_repo clean_pass
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
printf 'lib/touched.txt\t0\n' > .fake-lint
printf 'clean = 2\n' >> lib/touched.txt
run_gate
expect "a clean touched file passes" 0 "every touched file is clean"

new_repo residual_in_touched
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
printf 'lib/touched.txt\t3\n' > .fake-lint
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "any remaining issue in a touched file fails" 1 "lib/touched.txt(3)"

new_repo residual_in_untouched
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
printf 'lib/untouched.txt\t9\n' > .fake-lint
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "issues in untouched files are ignored" 0 "every touched file is clean"

new_repo residual_deferred
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/" "deferral_list=deferrals.md"
printf 'lib/touched.txt\t4\n' > .fake-lint
printf -- '- `lib/touched.txt` approved deferral, ticket 12\n' > deferrals.md
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "an approved deferral exempts a touched file" 0 "every touched file is clean"

new_repo baseline_regression
write_config "baseline_cmd=echo ratchet went up; exit 1" "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a failing baseline command is a never-tier failure" 1 "baseline increased: ratchet went up"

new_repo snapshot_flow
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
printf 'lib/untouched.txt\t5\n' > .fake-lint
run_gate
expect "the first run creates a snapshot" 0 "snapshot created at 5"
printf 'lib/untouched.txt\t6\n' > .fake-lint
run_gate
expect "a higher project total fails" 1 "project total rose from 5 to 6"
printf 'lib/untouched.txt\t2\n' > .fake-lint
run_gate
expect "a lower total passes and says how to bank it" 0 "rerun with --update-snapshot"
run_gate --update-snapshot
expect "update-snapshot banks the lower total" 0 "snapshot updated"
run_gate
expect "the banked total is the new floor" 0 "total unchanged at 2"

new_repo suppression_unapproved
write_config "suppression_pattern=credo:disable" "source_pattern=^lib/"
printf '# credo:disable-for-next-line Foo\n' >> lib/touched.txt
run_gate
expect "an added suppression needs approval" 2 "1 unapproved"

new_repo suppression_approved
write_config "suppression_pattern=credo:disable" "source_pattern=^lib/" "approvals_file=approvals.md"
printf '# credo:disable-for-next-line Foo\n' >> lib/touched.txt
printf 'approved-suppression: lib/touched.txt :: # credo:disable-for-next-line Foo\n' > approvals.md
run_gate
expect "an approved suppression passes" 0 "no unapproved suppressions added"

new_repo suppression_preexisting
printf '# credo:disable-for-next-line Old\n' >> lib/touched.txt
git add lib && git commit -q -m "chore: old suppression" && git checkout -q main && git merge -q feature && git checkout -q -b feature2
write_config "suppression_pattern=credo:disable" "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "suppressions that were already there are not flagged" 0 "no unapproved suppressions added"

new_repo legacy_whole_file
printf 'old = <%%= value %%>\n' >> lib/touched.txt
git add lib && git commit -q -m "chore: legacy" && git checkout -q main && git merge -q feature && git checkout -q -b feature2
write_config "legacy_pattern+=<%= => use { } interpolation" "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a legacy pattern on an untouched line of a touched file fails" 1 "lib/touched.txt:2 use: use { } interpolation"

new_repo standard_commands
write_config "format_cmd=exit 0" "test_cmd=echo 2 failures; exit 1" "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a failing test command fails" 1 "2 failures"
run_gate --quick
expect "quick mode skips tests" 0 "skipped in --quick"

new_repo outside_plan
write_config "source_pattern=^lib/"
printf 'planned = 1\n' >> lib/touched.txt
printf 'extra = 1\n' >> lib/untouched.txt
printf '### Task 1\n\n**Files:**\n- Modify: `lib/touched.txt:1-3`\n- Test: `test/x.txt`\n' > plan.md
run_gate --plan plan.md
expect "files outside the plan are reported, not failed" 0 "1 not in plan: lib/untouched.txt"

new_repo no_config
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a missing config skips project checks and says so" 0 "no config at"

new_repo unusual_paths
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
accented_path=$(printf 'lib/caf\303\251 notes.txt')
printf 'x = 1\n' > "$accented_path"
git add lib && git commit -q -m "chore: unusual name" && git checkout -q main && git merge -q feature && git checkout -q -b feature2
printf '%s\t2\n' "$accented_path" > .fake-lint
printf 'changed = 1\n' >> "$accented_path"
run_gate
expect "a non-ASCII path with a space is checked" 1 "notes.txt(2)"

new_repo missing_base_ref
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
printf 'lib/touched.txt\t1\n' > .fake-lint
printf 'changed = 1\n' >> lib/touched.txt
run_gate --base origin/does-not-exist
expect "an unresolvable base still sees uncommitted work" 1 "lib/touched.txt(1)"

new_repo missing_base_ref_row
write_config "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate --base origin/does-not-exist
expect "an unresolvable base is stated in the output" 0 "base origin/does-not-exist not found; committed changes not checked"

new_repo crashed_linter_keeps_snapshot
write_config "lint_counts_cmd=echo linter crashed >&2; exit 3" "source_pattern=^lib/"
printf '5\n' > .claude/context/lint-total.snapshot
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a crashed linter fails the ratchet instead of reading as zero" 1 "linter failed; project total not measured"
run_gate --update-snapshot
expect "update-snapshot never banks a crashed linter" 1 "linter failed; project total not measured"
if [ "$(cat .claude/context/lint-total.snapshot)" = "5" ]; then
  PASSED=$((PASSED + 1))
else
  FAILED=$((FAILED + 1))
  printf 'FAIL: the snapshot must stay at 5 after a linter crash\n'
fi

new_repo adapter_failure
write_config "lint_counts_cmd=echo linter crashed >&2; exit 3" "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a crashing adapter fails loudly instead of passing" 1 "command failed: linter crashed"

new_repo empty_and_deleted
write_config "lint_counts_cmd=cat .fake-lint" "format_cmd=exit 0" "source_pattern=^lib/"
: > .fake-lint
run_gate
expect "no touched files still runs the standard checks" 0 "every touched file is clean"
git rm -q lib/untouched.txt
run_gate
expect "a deleted file does not break the gate" 0 "every touched file is clean"

new_repo equals_in_command
write_config "format_cmd=MODE=check sh -c 'exit 0'" "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a command value containing = is kept whole" 0 "passed"

new_repo no_commits_yet
rm -rf .git
git init -q -b main
write_config "lint_counts_cmd=echo" "source_pattern=^lib/"
run_gate
expect "a repo with no commits still reports the missing base" 0 "base main not found"
case "$output" in
  *fatal:*)
    FAILED=$((FAILED + 1))
    printf 'FAIL: a repo with no commits must not print git errors\n%s\n' "$output"
    ;;
  *) PASSED=$((PASSED + 1)) ;;
esac
git add lib/touched.txt
printf 'lib/touched.txt\t2\n' > .fake-lint
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
run_gate
expect "staged files in a repo with no commits are still checked" 1 "lib/touched.txt(2)"

new_repo legacy_regex_with_arrow
printf 'm = %%{a => 1}\n' >> lib/touched.txt
git add lib && git commit -q -m "chore: map" && git checkout -q main && git merge -q feature && git checkout -q -b feature2
write_config 'legacy_pattern+=%\{.* => .*\} => use keyword lists' "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
run_gate
expect "a regex containing the arrow splits at the last arrow" 1 "lib/touched.txt:2 use: use keyword lists"

new_repo corrupt_snapshot
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/"
printf 'lib/untouched.txt\t5\n' > .fake-lint
printf '<<<<<<< HEAD\n5\n=======\n6\n>>>>>>> other\n' > .claude/context/lint-total.snapshot
cp .claude/context/lint-total.snapshot "$SANDBOX/corrupt.before"
run_gate
expect "a non-numeric snapshot fails the never-tier row" 1 "snapshot unreadable"
run_gate --update-snapshot
if cmp -s .claude/context/lint-total.snapshot "$SANDBOX/corrupt.before"; then
  PASSED=$((PASSED + 1))
else
  FAILED=$((FAILED + 1))
  printf 'FAIL: an unreadable snapshot must never be overwritten\n'
fi
case "$output" in
  *Illegal*|*"integer expression"*)
    FAILED=$((FAILED + 1))
    printf 'FAIL: a non-numeric snapshot must not leak shell errors\n%s\n' "$output"
    ;;
  *) PASSED=$((PASSED + 1)) ;;
esac

new_repo unwritable_snapshot
write_config "lint_counts_cmd=cat .fake-lint" "source_pattern=^lib/" "snapshot_file=missing-dir/total.snapshot"
printf 'lib/untouched.txt\t5\n' > .fake-lint
run_gate
expect "a failed snapshot write fails instead of claiming creation" 1 "could not write missing-dir/total.snapshot"

new_repo no_config_names_path
printf 'changed = 1\n' >> lib/touched.txt
run_gate --config elsewhere/gate.conf
expect "the missing-config message names the path that was looked for" 0 "no config at elsewhere/gate.conf"

new_repo missing_option_value
for option in --config --plan --base; do
  run_gate "$option"
  expect "$option without a value is a usage error" 64 "missing value for $option"
done

new_repo run_from_subdirectory
write_config "source_pattern=^lib/"
printf 'changed = 1\n' >> lib/touched.txt
cd lib || exit 1
run_gate
expect "running below the repository root is a usage error" 64 "run the gate from the repository root"
cd "$repo" || exit 1

new_repo no_commits_from_root
rm -rf .git
git init -q -b main
write_config "source_pattern=^lib/"
run_gate
expect "a repo with no commits is still accepted at its root" 0 "base main not found"

new_repo no_commits_from_subdirectory
rm -rf .git
git init -q -b main
write_config "source_pattern=^lib/"
cd lib || exit 1
run_gate
expect "a repo with no commits is still rejected below its root" 64 "run the gate from the repository root"
cd "$repo" || exit 1

new_repo "path with spaces"
write_config "source_pattern=^lib/"
run_gate
expect "a repository path containing spaces is accepted at its root" 0 "STATUS"
cd lib || exit 1
run_gate
expect "a repository path containing spaces is rejected below its root" 64 "run the gate from the repository root"
cd "$repo" || exit 1

new_repo symlink_target
write_config "source_pattern=^lib/"
ln -s "$repo" "$SANDBOX/symlink_entry"
cd "$SANDBOX/symlink_entry" || exit 1
run_gate
expect "the root reached through a symlink is accepted" 0 "STATUS"
cd "$repo" || exit 1

new_repo outside_git
write_config "source_pattern=^lib/"
outside="$SANDBOX/not_a_repo"
mkdir -p "$outside/.claude/context"
cp .claude/context/quality-gate.conf "$outside/.claude/context/"
cd "$outside" || exit 1
run_gate
expect "outside any repository the gate still runs" 0 "STATUS"
cd "$repo" || exit 1

new_repo capitalised_root
write_config "source_pattern=^lib/"
shouted_repo=$(printf '%s' "$repo" | tr '[:lower:]' '[:upper:]')
if [ -d "$shouted_repo" ] && [ "$(ls -di "$shouted_repo" | cut -d' ' -f1)" = "$(ls -di "$repo" | cut -d' ' -f1)" ]; then
  cd "$shouted_repo" || exit 1
  run_gate
  expect "the root reached through a differently capitalised path is accepted" 0 "STATUS"
  cd "$repo" || exit 1
else
  printf 'SKIP: case-sensitive filesystem, capitalised-root check not applicable\n'
fi

printf '\n%s passed, %s failed\n' "$PASSED" "$FAILED"
[ "$FAILED" -eq 0 ]
