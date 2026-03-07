import os

# Get all dart files in lib/
lib_files = []
for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            full_path = os.path.join(root, file)
            lib_files.append(full_path.replace('lib/', ''))

# Get files from coverage
with open('coverage_analysis.txt', 'r') as f:
    covered_files = set()
    for line in f.readlines()[2:]:  # Skip header
        if ':' in line:
            file_name = line.split(':')[0].strip()
            covered_files.add(file_name)

print("Files in lib/ not in coverage report:")
for f in sorted(lib_files):
    if f not in covered_files:
        print(f"  {f}")

print(f"\nTotal lib files: {len(lib_files)}")
print(f"Covered files: {len(covered_files)}")
print(f"Missing from coverage: {len(lib_files) - len(covered_files)}")
