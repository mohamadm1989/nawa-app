# 🏗️ الهيكل التقني والمعمارية
## مشروع نِواة – Nawa

---

## 🎯 نظرة عامة على الهيكل التقني

### 💡 **الفلسفة التقنية:**
بناء تطبيق قوي وقابل للتوسع يعمل بسلاسة حتى في ظروف الإنترنت الضعيف، مع التركيز على الأمان والشفافية والأداء السريع.

### 🎪 **المبادئ الأساسية:**
- **البساطة في التعقيد:** هيكل تقني متقدم مع واجهة بسيطة
- **الأداء أولاً:** تحميل سريع حتى مع الإنترنت البطيء
- **الأمان المطلق:** حماية البيانات والمعاملات المالية
- **القابلية للتوسع:** استعداد للنمو السريع

---

## 🏗️ معمارية التطبيق (App Architecture)

### 📱 **Frontend - Flutter**
```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│  ┌─────────────────────────────────┐│
│  │        UI Widgets               ││
│  │  • Screens                      ││
│  │  • Components                   ││
│  │  • Animations                   ││
│  └─────────────────────────────────┘│
│  ┌─────────────────────────────────┐│
│  │      State Management           ││
│  │  • Bloc/Cubit                   ││
│  │  • Provider                     ││
│  │  • Riverpod                     ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
│
┌─────────────────────────────────────┐
│           Business Layer            │
│  ┌─────────────────────────────────┐│
│  │       Use Cases                 ││
│  │  • Project Management           ││
│  │  • User Authentication          ││
│  │  • Donation Processing          ││
│  └─────────────────────────────────┘│
│  ┌─────────────────────────────────┐│
│  │      Repositories               ││
│  │  • Abstract Interfaces          ││
│  │  • Data Transformation          ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
│
┌─────────────────────────────────────┐
│            Data Layer               │
│  ┌─────────────────────────────────┐│
│  │     Remote Data Sources         ││
│  │  • Firebase Firestore           ││
│  │  • Firebase Storage             ││
│  │  • Firebase Auth                ││
│  └─────────────────────────────────┘│
│  ┌─────────────────────────────────┐│
│  │     Local Data Sources          ││
│  │  • SQLite (Hive)                ││
│  │  • Shared Preferences           ││
│  │  • Secure Storage               ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

### ☁️ **Backend - Firebase**
```
┌─────────────────────────────────────┐
│           Firebase Services         │
│                                     │
│  🔥 Firestore Database              │
│  ├── Users Collection               │
│  ├── Projects Collection            │
│  ├── Donations Collection           │
│  ├── Comments Collection            │
│  └── Notifications Collection       │
│                                     │
│  🔐 Firebase Authentication         │
│  ├── Phone Number Auth              │
│  ├── Email/Password Auth            │
│  └── Social Media Auth              │
│                                     │
│  📁 Firebase Storage                │
│  ├── Project Images                 │
│  ├── User Avatars                   │
│  ├── Documents                      │
│  └── Progress Photos                │
│                                     │
│  ⚡ Cloud Functions                 │
│  ├── Payment Processing             │
│  ├── Notifications                  │
│  ├── Data Validation                │
│  └── Analytics                      │
│                                     │
│  📊 Firebase Analytics              │
│  └── User Behavior Tracking         │
└─────────────────────────────────────┘
```

---

## 🗄️ تصميم قاعدة البيانات

### 👥 **Users Collection**
```json
{
  "uid": "user_unique_id",
  "profile": {
    "name": "أحمد محمد",
    "phone": "+963912345678",
    "email": "ahmed@example.com",
    "avatar": "storage_url",
    "location": {
      "city": "حلب",
      "country": "سوريا",
      "coordinates": {
        "lat": 36.2021,
        "lng": 37.1343
      }
    },
    "userType": "local", // local, diaspora
    "interests": ["education", "health", "environment"],
    "skills": ["programming", "teaching", "construction"]
  },
  "stats": {
    "totalDonations": 500.00,
    "projectsSupported": 12,
    "projectsCreated": 2,
    "volunteeredHours": 24,
    "badges": ["first_donation", "community_hero"]
  },
  "settings": {
    "language": "ar",
    "notifications": true,
    "privacy": {
      "showName": true,
      "showDonations": false
    }
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### 🏗️ **Projects Collection**
```json
{
  "projectId": "project_unique_id",
  "basic": {
    "title": "ترميم مدرسة الأمل",
    "description": "وصف مفصل للمشروع...",
    "category": "education",
    "status": "active", // pending, active, completed, cancelled
    "priority": "high",
    "tags": ["school", "renovation", "children"]
  },
  "location": {
    "city": "حلب",
    "district": "الصالحين",
    "address": "شارع المدرسة، بناء رقم 15",
    "coordinates": {
      "lat": 36.2021,
      "lng": 37.1343
    }
  },
  "financial": {
    "targetAmount": 5000.00,
    "currentAmount": 2500.00,
    "currency": "USD",
    "breakdown": {
      "materials": 3000.00,
      "labor": 1500.00,
      "other": 500.00
    }
  },
  "timeline": {
    "createdAt": "timestamp",
    "startDate": "timestamp",
    "expectedEndDate": "timestamp",
    "actualEndDate": null
  },
  "creator": {
    "uid": "creator_user_id",
    "name": "أبو محمد",
    "role": "مدير المدرسة",
    "contact": "+963912345678"
  },
  "media": {
    "mainImage": "storage_url",
    "gallery": ["url1", "url2", "url3"],
    "documents": ["permit_url", "plan_url"]
  },
  "engagement": {
    "supporters": 25,
    "likes": 45,
    "comments": 12,
    "shares": 8,
    "views": 234
  },
  "verification": {
    "status": "verified",
    "verifiedBy": "admin_user_id",
    "verificationDate": "timestamp",
    "documents": ["verification_doc_url"]
  }
}
```

### 💰 **Donations Collection**
```json
{
  "donationId": "donation_unique_id",
  "donor": {
    "uid": "donor_user_id",
    "name": "فاطمة أحمد", // optional based on privacy
    "anonymous": false
  },
  "project": {
    "projectId": "target_project_id",
    "title": "ترميم مدرسة الأمل"
  },
  "amount": {
    "value": 50.00,
    "currency": "USD",
    "localAmount": 75000, // in Syrian Pounds
    "exchangeRate": 1500
  },
  "payment": {
    "method": "credit_card", // credit_card, paypal, bank_transfer
    "transactionId": "stripe_transaction_id",
    "status": "completed", // pending, completed, failed, refunded
    "gateway": "stripe"
  },
  "metadata": {
    "donationType": "one_time", // one_time, recurring
    "message": "رسالة من المتبرع للمستفيدين",
    "dedicatedTo": "في ذكرى والدي رحمه الله"
  },
  "timestamps": {
    "createdAt": "timestamp",
    "processedAt": "timestamp",
    "confirmedAt": "timestamp"
  }
}
```

### 💬 **Comments Collection**
```json
{
  "commentId": "comment_unique_id",
  "projectId": "target_project_id",
  "author": {
    "uid": "author_user_id",
    "name": "محمد علي",
    "avatar": "avatar_url"
  },
  "content": {
    "text": "مشروع رائع، الله يوفقكم",
    "images": ["image_url1", "image_url2"]
  },
  "engagement": {
    "likes": 5,
    "replies": 2
  },
  "moderation": {
    "status": "approved", // pending, approved, rejected
    "moderatedBy": "moderator_user_id",
    "moderatedAt": "timestamp"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### 🔔 **Notifications Collection**
```json
{
  "notificationId": "notification_unique_id",
  "recipient": {
    "uid": "recipient_user_id",
    "fcmToken": "firebase_messaging_token"
  },
  "content": {
    "title": "تحديث في مشروعك",
    "body": "تم الانتهاء من ترميم الصف الأول",
    "image": "notification_image_url",
    "action": {
      "type": "open_project",
      "data": {
        "projectId": "project_id"
      }
    }
  },
  "status": {
    "sent": true,
    "delivered": true,
    "read": false
  },
  "timestamps": {
    "createdAt": "timestamp",
    "sentAt": "timestamp",
    "readAt": null
  }
}
```

---

## 🔧 التقنيات والمكتبات

### 📱 **Flutter Dependencies**
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  provider: ^6.0.5
  
  # Firebase
  firebase_core: ^2.15.1
  firebase_auth: ^4.9.0
  cloud_firestore: ^4.9.1
  firebase_storage: ^11.2.6
  firebase_messaging: ^14.6.7
  firebase_analytics: ^10.4.5
  
  # UI & Design
  google_fonts: ^5.1.0
  flutter_svg: ^2.0.7
  cached_network_image: ^3.2.3
  shimmer: ^3.0.0
  lottie: ^2.6.0
  
  # Functionality
  image_picker: ^1.0.2
  geolocator: ^9.0.2
  url_launcher: ^6.1.12
  share_plus: ^7.1.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  
  # Network & API
  dio: ^5.3.2
  connectivity_plus: ^4.0.2
  
  # Payments
  stripe_payment: ^1.1.4
  
  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
  
  # Utils
  uuid: ^3.0.7
  timeago: ^3.4.0
  flutter_launcher_icons: ^0.13.1
```

### ☁️ **Firebase Configuration**
```javascript
// Cloud Functions (Node.js)
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')(functions.config().stripe.secret);

// Payment Processing
exports.processPayment = functions.https.onCall(async (data, context) => {
  // Payment logic here
});

// Send Notifications
exports.sendNotification = functions.firestore
  .document('projects/{projectId}')
  .onUpdate(async (change, context) => {
    // Notification logic here
  });
```

---

## 🔒 الأمان والحماية

### 🛡️ **Firebase Security Rules**
```javascript
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Projects are readable by all, writable by creator
    match /projects/{projectId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        (request.auth.uid == resource.data.creator.uid || 
         request.auth.token.admin == true);
    }
    
    // Donations are private to donor and project creator
    match /donations/{donationId} {
      allow read: if request.auth != null && 
        (request.auth.uid == resource.data.donor.uid ||
         request.auth.uid == get(/databases/$(database)/documents/projects/$(resource.data.project.projectId)).data.creator.uid);
      allow create: if request.auth != null;
    }
  }
}
```

### 🔐 **Data Encryption**
- **في النقل:** HTTPS/TLS 1.3 لجميع الاتصالات
- **في التخزين:** تشفير Firebase الافتراضي + تشفير إضافي للبيانات الحساسة
- **البيانات المالية:** تشفير AES-256 قبل التخزين
- **كلمات المرور:** bcrypt hashing مع salt

---

## 📊 الأداء والتحسين

### ⚡ **استراتيجيات الأداء:**
- **Lazy Loading:** تحميل البيانات عند الحاجة فقط
- **Image Caching:** تخزين الصور محلياً لتقليل استهلاك البيانات
- **Pagination:** تحميل المشاريع على دفعات (10-20 مشروع)
- **Offline Support:** تخزين البيانات الأساسية محلياً

### 📱 **تحسين للأجهزة الضعيفة:**
```dart
// تحسين الذاكرة
class OptimizedImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      memCacheWidth: 300, // تقليل استهلاك الذاكرة
      placeholder: (context, url) => ShimmerWidget(),
      errorWidget: (context, url, error) => DefaultImage(),
    );
  }
}
```

### 🌐 **دعم الاتصال الضعيف:**
```dart
// مراقبة حالة الاتصال
class ConnectivityService {
  static Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  static void handleOfflineMode() {
    // تفعيل الوضع الأوفلاين
    // عرض البيانات المحفوظة محلياً
  }
}
```

---

## 🚀 خطة التطوير المرحلية

### 📅 **المرحلة الأولى (الأسابيع 1-4): الأساسيات**
- ✅ إعداد مشروع Flutter ← **مكتمل**
- ✅ تطبيق نظام الألوان والخطوط ← **مكتمل**
- ✅ إنشاء المكونات الأساسية ← **مكتمل**
- ✅ شاشة الترحيب ← **مكتمل**
- ⏳ تكوين Firebase
- ✅ تصميم قاعدة البيانات
- ⏳ تطوير نظام المصادقة
- ⏳ الواجهات الأساسية (الرئيسية، تفاصيل المشروع)

### 📅 **المرحلة الثانية (الأسابيع 5-7): التبرعات**
- 💳 تكامل نظام الدفع
- 💰 واجهة التبرع
- 📊 تتبع التبرعات
- 🔔 نظام الإشعارات الأساسي

### 📅 **المرحلة الثالثة (الأسابيع 8-10): التحسينات**
- 🔍 البحث والتصفية
- 💬 نظام التعليقات
- 📤 المشاركة الاجتماعية
- 📱 تحسينات الأداء

---

## 🧪 الاختبار وضمان الجودة

### 🔬 **أنواع الاختبارات:**
- **Unit Tests:** اختبار الوظائف الفردية
- **Widget Tests:** اختبار واجهات المستخدم
- **Integration Tests:** اختبار التدفق الكامل
- **Performance Tests:** اختبار الأداء والسرعة

### 📱 **اختبار الأجهزة:**
- أجهزة Android مختلفة (من الضعيفة للقوية)
- شبكات مختلفة (WiFi، 4G، 3G، 2G)
- أنظمة تشغيل مختلفة (Android 7+)

### 👥 **اختبار المستخدمين:**
- مجموعة من المستخدمين داخل سوريا
- مجموعة من المغتربين السوريين
- اختبار سهولة الاستخدام والفهم
