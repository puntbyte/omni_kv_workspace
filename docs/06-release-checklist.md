# 6. Release checklist

Before publishing:

```bash
dart pub get
melos run format:apply
melos run analyze
melos run test
melos run publish:dry-run
```

Check:

- Every publishable package has a license.
- No `.dart_tool`, `build`, or lock files are committed.
- No package depends on unpublished test utilities.
- Version numbers are aligned.
