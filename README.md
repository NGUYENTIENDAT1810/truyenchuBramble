# 🌿 Bramble - Modern Minimalist Novel Reader Platform

Bramble is a mobile-first, production-ready novel reader platform inspired by the editorial design prototype `BrambleScreen.dc.html`. It features warm cream/sepia/night themes, rich typography (`Caprasimo`, `Figtree`, `Lora`), an advanced distraction-free reader engine, chapter discussions, reading stats & streak tracking, offline reading capabilities, and a layered **Java Spring Boot 3.3.x** REST backend with PostgreSQL, Flyway, Spring Security, JWT, and OpenAPI 3.0 documentation.

---

## 📱 App Highlights

- **Aesthetic Editorial Design**:
  - 3 Reader Themes: **Cream** (`#f5ead8`), **Sepia** (`#e8d7b4`), **Night** (`#211f1c`).
  - Font choices: **Lora** (warm book serif) & **Figtree** (interface sans).
  - Floating pill bottom navigation & smooth sheet transitions.
- **Advanced Reader Engine**:
  - Tap-to-toggle reader chrome (Top sticky header & Bottom reading progress indicator).
  - Customizable font size (15px-26px), line spacing (1.3-2.4), and margins (Narrow, Regular, Wide).
  - Paragraph-level likes and inline note jump points.
  - Automatic progress tracking & estimated reading time calculation.
  - Offline reading support: downloaded chapters cache locally and synchronize seamlessly when online.
- **Engaging Social & Library System**:
  - Filterable library shelf: *Reading*, *Saved*, *Downloaded*.
  - Chapter discussion threads with paragraph quote references.
  - Author profiles with bibliography and follower support.
  - Reading goals ring & 7-day reading habit bar chart.
- **Enterprise-Grade Java Spring Boot Backend**:
  - Spring Boot 3.3.3 + Java 17 LTS + Spring Data JPA + Hibernate + PostgreSQL.
  - Spring Security with Stateless JWT Authentication & Refresh Token Rotation.
  - Flyway database migration scripts (`db/migration/V1__create_tables.sql`).
  - Bean Validation (`jakarta.validation`) and centralized `GlobalExceptionHandler`.
  - Layered Architecture (`controller/`, `service/`, `repository/`, `entity/`, `dto/`, `mapper/`, `security/`, `config/`, `exception/`).
  - Interactive OpenAPI / Swagger UI documentation at `/swagger-ui.html`.
  - Automated `DataSeeder` with 10+ novels, chapters, authors, genres, and comments.

---

## 🛠️ Tech Stack

### Frontend (Mobile)
- **Framework**: Flutter 3.22+
- **State Management**: Riverpod (`flutter_riverpod`)
- **Routing**: `go_router` (with `ShellRoute` for navigation bar)
- **HTTP Client**: `dio` (with `AuthInterceptor` & token refresh)
- **Typography**: Google Fonts (`Caprasimo`, `Figtree`, `Lora`)
- **Local Storage**: `shared_preferences`

### Backend (API)
- **Framework**: Java 17 LTS + Spring Boot 3.3.3 + Maven
- **Database & Migration**: PostgreSQL 16 & Flyway Migration
- **Security**: Spring Security + JJWT 0.12.5 + BCrypt
- **API Docs**: Springdoc OpenAPI 2.6.0 (Swagger UI)
- **Containerization**: Multi-stage Docker & Docker Compose

---

## 🚀 Quick Start Guide

### 1. Prerequisites
- [Java 17+ LTS](https://www.oracle.com/java/technologies/downloads/)
- [Flutter SDK](https://flutter.dev/) (v3.22+)
- [Docker & Docker Compose](https://www.docker.com/)

---

### 2. Backend Setup & Run

#### Option A: Run via Docker Compose (Recommended)
```bash
docker compose up --build -d
```
This starts:
1. **PostgreSQL** on port `5432` (`bramble_db`)
2. **Spring Boot API** on `http://localhost:8080`
3. Automatically executes Flyway migrations and seeds demo novels, authors, chapters, and comments.

#### Option B: Run Locally with Maven / H2 In-Memory (Dev Profile)
```bash
cd backend

# Build and run with dev profile (uses embedded H2 database & automatic seed)
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

- Backend API Base URL: `http://localhost:8080/api`
- Swagger UI Documentation: `http://localhost:8080/swagger-ui.html`
- OpenAPI JSON Spec: `http://localhost:8080/v3/api-docs`

---

### 3. Flutter Mobile App Setup & Run

```bash
cd mobile

# 1. Fetch dependencies
flutter pub get

# 2. Run unit & widget tests
flutter test

# 3. Run application
flutter run
```

> **Note for Android Emulator**: The app automatically resolves backend host to `http://10.0.2.2:8080/api`. On Web/iOS/Desktop it resolves to `http://localhost:8080/api`.

---

## 🔑 Demo Accounts

| Role | Email | Password | Features |
|---|---|---|---|
| **Reader** | `noor@example.com` | `password123` | Pre-loaded shelf, active reading on *The Starlit Citadel*, 350 coins |
| **Admin** | `admin@bramble.com` | `admin123` | Full admin privileges for novels & chapters via `/api/admin/**` |

---

## 📖 API Endpoints Reference

### Authentication & Profile (`/api/auth` & `/api/users/me`)
- `POST /api/auth/register` - Create new reader account
- `POST /api/auth/login` - Login with email & password (returns JWT & refresh token)
- `POST /api/auth/refresh` - Refresh access token
- `POST /api/auth/logout` - Invalidate refresh token
- `GET /api/users/me` - Get current user profile and preferences
- `PUT /api/users/me/preferences` - Update user theme, font size, margins, sound effects

### Catalog & Discovery (`/api/books` & `/api/discover`)
- `GET /api/books` - List/filter books with pagination (`search`, `genre`, `status`, `sortBy`, `page`, `limit`)
- `GET /api/books/{id}` - Book details with user reading progress & chapter previews
- `GET /api/discover` - Featured, trending, new releases, and popular genres
- `GET /api/authors` - List of authors
- `GET /api/authors/{id}` - Author profile with bibliography
- `POST /api/authors/{id}/follow` - Toggle follow author
- `GET /api/genres` - List of all genres

### Chapters & Reader (`/api/chapters` & `/api/me/books`)
- `GET /api/books/{bookId}/chapters` - Table of contents (with lock status)
- `GET /api/chapters/{id}` - Chapter text content & navigation metadata (Prev/Next)
- `POST /api/chapters/{id}/unlock` - Unlock premium chapter using coins
- `GET /api/me/active-reading` - Retrieve currently active novel & reading progress
- `GET /api/me/books/{bookId}/progress` - Retrieve reading progress for a novel
- `POST /api/me/books/{bookId}/progress` - Synchronize reading position, scroll offset, and reading time

### Library & Shelves (`/api/me/library`)
- `GET /api/me/library` - User library shelf (filtered by `status`: CURRENT, COMPLETED, SAVED)
- `POST /api/me/library` - Save book to library
- `PATCH /api/me/library/{bookId}` - Update reading status
- `DELETE /api/me/library/{bookId}` - Remove book from library

### Comments & Community (`/api/chapters/{chapterId}/comments`)
- `GET /api/chapters/{chapterId}/comments` - Chapter comments & paragraph notes
- `POST /api/chapters/{chapterId}/comments` - Post comment (with optional paragraph index)
- `POST /api/comments/{id}/like` - Toggle like comment

### Reading Statistics (`/api/me/stats`)
- `GET /api/me/stats` - Reading streak, total minutes read, books completed, weekly activity chart

### Admin Management (`/api/admin`)
- `POST /api/admin/books` - Create novel
- `PUT /api/admin/books/{id}` - Update novel
- `DELETE /api/admin/books/{id}` - Delete novel
- `POST /api/admin/books/{bookId}/chapters` - Create chapter
- `PUT /api/admin/chapters/{id}` - Update chapter
- `DELETE /api/admin/chapters/{id}` - Delete chapter

---

## 📦 Build for Production (APK)

```bash
cd mobile
flutter build apk --release
```
The output APK will be located at `mobile/build/app/outputs/flutter-apk/app-release.apk`.
