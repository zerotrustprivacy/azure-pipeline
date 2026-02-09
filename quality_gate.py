import subprocess
import sys

def run_command(command, error_message):
    """Runs a shell command and exits if it fails."""
    try:
        # Run the command and capture output
        result = subprocess.run(
            command,
            shell=True,
            check=True,
            text=True,
            capture_output=True
        )
        print(f"[PASS] {command}")
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"\n[FAIL] {error_message}")
        print(f"Details:\n{e.stderr}")
        print(f"Output:\n{e.stdout}")
        sys.exit(1)

def main():
    print("Starting Quality Gate Checks...\n")

    # 1. Linting (Style Check)
    # Enforces coding standards (JD Requirement: "coding standards for test automation")
    run_command(
        "flake8 app/ tests/ --count --select=E9,F63,F7,F82 --show-source --statistics",
        "Code style violation found. Please fix linting errors."
    )

    # 2. Security Scan (Static Analysis)
    # Checks for common security issues (JD Requirement: "security scanning concepts")
    run_command(
        "bandit -r app/",
        "Security vulnerability detected. Review bandit report."
    )

    # 3. Unit Tests & Coverage
    # Enforces coverage threshold (JD Requirement: "achieve high automation coverage")
    # This command fails if coverage is under 80%
    run_command(
        "pytest --cov=app --cov-fail-under=80 tests/",
        "Unit tests failed or coverage is below 80%."
    )

    print("\nSUCCESS: All Quality Gates Passed. Ready for Deployment.")

if __name__ == "__main__":
    main()
