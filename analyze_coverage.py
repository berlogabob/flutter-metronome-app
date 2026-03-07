import re

# Parse lcov.info
with open('coverage/lcov.info', 'r') as f:
    content = f.read()

# Extract file coverage data
files = re.findall(r'SF:(.+?)\n((?:DA:.*?\n)+)', content)

coverage_data = []
for file_path, data in files:
    lines = re.findall(r'DA:(\d+),(\d+)', data)
    total = len(lines)
    covered = sum(1 for _, count in lines if int(count) > 0)
    percentage = (covered / total * 100) if total > 0 else 0
    coverage_data.append({
        'file': file_path.replace('lib/', ''),
        'total': total,
        'covered': covered,
        'percentage': percentage
    })

# Sort by coverage percentage
coverage_data.sort(key=lambda x: x['percentage'])

# Print summary
print("=" * 80)
print("COVERAGE ANALYSIS REPORT")
print("=" * 80)

total_lines = sum(f['total'] for f in coverage_data)
total_covered = sum(f['covered'] for f in coverage_data)
overall_percentage = (total_covered / total_lines * 100) if total_lines > 0 else 0

print(f"\nOverall Coverage: {total_covered}/{total_lines} lines ({overall_percentage:.2f}%)")
print(f"Files analyzed: {len(coverage_data)}")

print("\n" + "=" * 80)
print("FILES WITH 0% COVERAGE")
print("=" * 80)
zero_coverage = [f for f in coverage_data if f['percentage'] == 0]
for f in zero_coverage:
    print(f"{f['file']}: {f['covered']}/{f['total']} lines (0%)")

print("\n" + "=" * 80)
print("FILES WITH < 50% COVERAGE")
print("=" * 80)
low_coverage = [f for f in coverage_data if 0 < f['percentage'] < 50]
for f in low_coverage:
    print(f"{f['file']}: {f['covered']}/{f['total']} lines ({f['percentage']:.1f}%)")

print("\n" + "=" * 80)
print("FILES WITH 50-85% COVERAGE")
print("=" * 80)
medium_coverage = [f for f in coverage_data if 50 <= f['percentage'] < 85]
for f in medium_coverage:
    print(f"{f['file']}: {f['covered']}/{f['total']} lines ({f['percentage']:.1f}%)")

print("\n" + "=" * 80)
print("FILES WITH 85-100% COVERAGE")
print("=" * 80)
high_coverage = [f for f in coverage_data if f['percentage'] >= 85]
for f in high_coverage:
    print(f"{f['file']}: {f['covered']}/{f['total']} lines ({f['percentage']:.1f}%)")

# Save detailed data
with open('coverage_analysis.txt', 'w') as f:
    f.write("COVERAGE ANALYSIS\n")
    f.write(f"Overall: {overall_percentage:.2f}%\n\n")
    for item in coverage_data:
        f.write(f"{item['file']}: {item['covered']}/{item['total']} ({item['percentage']:.2f}%)\n")

print(f"\nDetailed analysis saved to coverage_analysis.txt")
