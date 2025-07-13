# Security Policy

## 🛡️ Supported Versions

| Version | Supported        |
| ------- | ---------------- |
| 1.0.x   | ✅ Current       |
| < 1.0   | ❌ Not supported |

## 🔒 Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

### 📧 Contact

- **Email**: hieu555x@gmail.com
- **Subject**: [SECURITY] Blog App Vulnerability Report

### 📋 What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### ⏱️ Response Time

- **Initial Response**: Within 48 hours
- **Fix Timeline**: 7-14 days for critical issues
- **Public Disclosure**: After fix is released

## 🔐 Security Measures

### **Code Security**

- ✅ Input validation on all user inputs
- ✅ SQL injection prevention with Supabase RLS
- ✅ Authentication required for sensitive operations
- ✅ No hardcoded secrets in repository

### **API Security**

- ✅ Row Level Security (RLS) on database
- ✅ JWT token authentication
- ✅ Rate limiting on API endpoints
- ✅ HTTPS only communication

### **Build Security**

- ✅ Automated security scanning in CI/CD
- ✅ Dependency vulnerability checks
- ✅ Code analysis for security issues
- ✅ No debug information in release builds

### **Data Protection**

- ✅ User data encrypted in transit and at rest
- ✅ Minimal data collection
- ✅ Local data encrypted with Hive
- ✅ Secure file upload with validation

## ⚠️ Security Best Practices

### **For Users**

- Enable screen lock on your device
- Download APK only from official releases
- Keep the app updated to latest version
- Review app permissions before installation

### **For Developers**

- Never commit secrets to version control
- Use environment variables for sensitive data
- Review dependencies for vulnerabilities
- Follow secure coding practices

## 🚨 Security Checklist

- [ ] All secrets in environment variables
- [ ] Database RLS policies implemented
- [ ] Input validation on all forms
- [ ] File upload restrictions in place
- [ ] Authentication checks on sensitive routes
- [ ] Error messages don't reveal sensitive info
- [ ] Dependencies regularly updated
- [ ] Security headers configured

## 📚 Security Resources

- [Supabase Security Best Practices](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter Security Guide](https://flutter.dev/docs/deployment/security)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security-testing-guide/)

---

_Security is a top priority for the Blog App project. Thank you for helping keep our users safe._
