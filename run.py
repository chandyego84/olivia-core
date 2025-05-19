# run.py

import subprocess
import os
import sys

def run_pipeline():
    print("Assembling input.asm...")

    # assemble the input file
    result = subprocess.run(
        ["python", "assembler.py", "input.asm", "olivia_out.mem"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print("Assembler failed")
        print(result.stderr)
        sys.exit(1)

    # verify olivia_out.mem was created
    if not os.path.exists("olivia_out.mem"):
        print("Error: olivia_out.mem not generated")
        sys.exit(1)

    # run Verilog simulation via Makefile
    print("Running Verilog simulation...")

    try:
        subprocess.run(["make", "clean"], check=True)
        subprocess.run(["make"], check=True)
    except subprocess.CalledProcessError as e:
        print("Simulation failed")
        sys.exit(e.returncode)

    print("Simulation completed successfully")

if __name__ == "__main__":
    run_pipeline()
