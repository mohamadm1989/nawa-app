# 🚀 دليل رفع مشروع نوى على GitHub

## 📋 الخطوات المطلوبة

### **الخطوة 1: إنشاء Repository على GitHub**

1. **اذهب إلى GitHub.com** وسجل الدخول بحسابك
2. **اضغط على زر "New"** أو اذهب مباشرة إلى: https://github.com/new
3. **املأ تفاصيل Repository**:
   ```
   Repository name: nawa-app
   Description: 🌱 نوى - تطبيق إعادة الإعمار المجتمعي السوري | Syrian Community Reconstruction App built with Flutter
   Visibility: ✅ Public
   Initialize this repository with: لا تختر أي شيء (اتركها فارغة)
   ```
4. **اضغط "Create repository"**

### **الخطوة 2: ربط المشروع المحلي (تم بالفعل)**

✅ تم تنفيذ هذه الخطوات:
```bash
git init
git add .
git commit -m "Initial commit: Nawa Syrian Community Reconstruction App"
git remote add origin https://github.com/mohamadm1989/nawa-app.git
git branch -M main
```

### **الخطوة 3: رفع المشروع**

نفذ هذا الأمر في terminal:
```bash
git push -u origin main
```

**إذا طُلب منك المصادقة:**
- استخدم username: `mohamadm1989`
- استخدم Personal Access Token بدلاً من كلمة المرور

### **الخطوة 4: إنشاء Personal Access Token (إذا لزم الأمر)**

1. اذهب إلى: https://github.com/settings/tokens
2. اضغط "Generate new token" → "Generate new token (classic)"
3. أعطه اسم: `Nawa App Development`
4. اختر Scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
5. اضغط "Generate token"
6. **انسخ التوكن واحفظه** (لن تراه مرة أخرى!)

### **الخطوة 5: استخدام التوكن**

عند طلب كلمة المرور، استخدم التوكن بدلاً منها:
```
Username: mohamadm1989
Password: [paste your token here]
```

---

## 🔧 أوامر Git المفيدة

### **للتحديثات المستقبلية:**
```bash
# إضافة تغييرات جديدة
git add .

# عمل commit
git commit -m "وصف التحديث"

# رفع التحديثات
git push origin main
```

### **لإنشاء فرع جديد:**
```bash
# إنشاء فرع جديد
git checkout -b feature/new-feature

# رفع الفرع الجديد
git push -u origin feature/new-feature
```

### **لدمج التغييرات:**
```bash
# العودة للفرع الرئيسي
git checkout main

# دمج الفرع
git merge feature/new-feature

# رفع التحديثات
git push origin main
```

---

## 📁 ملفات مهمة تم إنشاؤها

✅ **README.md** - وصف شامل للمشروع
✅ **LICENSE** - رخصة MIT
✅ **.gitignore** - ملفات مستبعدة من Git
✅ **GITHUB_SETUP.md** - هذا الدليل

---

## 🌟 ميزات Repository

بعد رفع المشروع، ستحصل على:

### **📊 GitHub Features:**
- ✅ **Issues Tracking** - لتتبع المشاكل والطلبات
- ✅ **Pull Requests** - لمراجعة التغييرات
- ✅ **Projects** - لإدارة المهام
- ✅ **Wiki** - للتوثيق المفصل
- ✅ **Releases** - لإصدارات التطبيق
- ✅ **Actions** - للـ CI/CD (مستقبلاً)

### **🏷️ Topics المقترحة:**
أضف هذه الكلمات المفتاحية في إعدادات Repository:
```
flutter, dart, syria, reconstruction, donation, community, arabic, rtl, firebase, mobile-app, humanitarian, charity, syrian-app, material-design, cross-platform
```

### **🔗 Links مفيدة:**
- **Repository**: https://github.com/mohamadm1989/nawa-app
- **Issues**: https://github.com/mohamadm1989/nawa-app/issues
- **Projects**: https://github.com/mohamadm1989/nawa-app/projects
- **Wiki**: https://github.com/mohamadm1989/nawa-app/wiki

---

## 🚨 استكشاف الأخطاء

### **مشكلة المصادقة:**
```bash
# إذا فشلت المصادقة، استخدم:
git config --global credential.helper store
git push -u origin main
```

### **مشكلة SSL:**
```bash
# إذا كانت هناك مشكلة SSL:
git config --global http.sslVerify false
```

### **تحديث Remote URL:**
```bash
# لتحديث رابط Repository:
git remote set-url origin https://github.com/mohamadm1989/nawa-app.git
```

---

## ✅ التحقق من النجاح

بعد رفع المشروع بنجاح:

1. **اذهب إلى**: https://github.com/mohamadm1989/nawa-app
2. **تأكد من وجود جميع الملفات**
3. **تحقق من README.md** يظهر بشكل صحيح
4. **أضف وصف Repository** في الإعدادات
5. **أضف Topics** للمشروع

---

## 🎉 تهانينا!

مشروع **نوى** الآن على GitHub ومتاح للعالم! 🌍

**الخطوات التالية:**
- [ ] إضافة GitHub Actions للـ CI/CD
- [ ] إنشاء GitHub Pages للتوثيق
- [ ] إعداد Issue Templates
- [ ] إنشاء Contributing Guidelines
- [ ] إضافة Code of Conduct

**معاً نبني سوريا الجديدة** 🇸🇾
