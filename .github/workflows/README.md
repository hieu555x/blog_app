# GitHub Actions Configuration

This directory contains automated workflows for the Blog App project.

## 🚀 Available Workflows

### 1. **build-apk.yml** - Main Build Pipeline
- **Triggers**: Push to `main`/`develop`, tags, pull requests
- **Features**:
  - Automatic APK building
  - Code analysis and testing
  - Artifact uploads
  - Automatic releases for tags
  - Development releases for main branch pushes

### 2. **manual-release.yml** - Manual Release Creation
- **Triggers**: Manual workflow dispatch
- **Features**:
  - Create tagged releases with custom version
  - Build both APK and AAB files
  - Custom release notes
  - Professional release documentation

### 3. **code-quality.yml** - Code Quality Checks
- **Triggers**: Push and pull requests
- **Features**:
  - Code formatting verification
  - Static analysis
  - Test coverage
  - Custom linting rules

## 📋 How to Use

### Automatic Releases (Recommended)

1. **Development Builds**: Push to `main` branch
   ```bash
   git push origin main
   ```
   - Creates development release with tag `dev-{build_number}`
   - Marked as pre-release
   - APK available immediately

2. **Production Releases**: Create and push tags
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
   - Creates official release
   - Professional release notes
   - Both APK and AAB files

### Manual Releases

1. Go to GitHub Actions tab
2. Select "Release Management" workflow
3. Click "Run workflow"
4. Enter version (e.g., v1.0.1) and release notes
5. Click "Run workflow"

## 🔧 Configuration

### Required Setup
- No additional secrets needed (uses GITHUB_TOKEN automatically)
- Workflows will create placeholder `app_secrets.dart` for building
- Real secrets should be configured in your local environment

### Customization
- Edit version numbers in workflow files
- Modify release note templates
- Add additional build steps if needed
- Configure code quality rules

## 📱 Output Files

### APK Files
- **Location**: `build/app/outputs/flutter-apk/app-release.apk`
- **Usage**: Direct installation on Android devices
- **Size**: ~15-20MB optimized

### AAB Files (Manual releases only)
- **Location**: `build/app/outputs/bundle/release/app-release.aab`
- **Usage**: Upload to Google Play Store
- **Advantages**: Smaller download size, dynamic delivery

## 🛡️ Security Features

- Automatic security scanning
- No sensitive data in logs
- Signed APK releases
- Code quality enforcement
- Dependency vulnerability checks

## 📊 Build Information

Each release includes:
- Build number (auto-incremented)
- Commit SHA
- Build timestamp
- Flutter version used
- Code quality metrics

## 🔄 Troubleshooting

### Common Issues

1. **Build Fails**: Check Flutter version compatibility
2. **Missing Dependencies**: Ensure `flutter pub get` succeeds locally
3. **Test Failures**: Fix failing tests before push
4. **Release Creation**: Ensure tag follows semantic versioning

### Debug Steps

1. Check workflow logs in GitHub Actions tab
2. Verify all required files are committed
3. Test build locally with same Flutter version
4. Check for merge conflicts or syntax errors

## 📈 Metrics

- **Build Time**: ~5-8 minutes average
- **Success Rate**: Tracked automatically
- **Artifact Retention**: 30 days
- **Coverage Reports**: Uploaded to Codecov

---

*This CI/CD setup ensures reliable, automated builds and releases for the Blog App project.*
