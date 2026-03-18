# Pinterest Clone App

Aplicación móvil desarrollada en Flutter que replica la experiencia básica de una red social visual similar a Pinterest. El proyecto está enfocado en demostrar habilidades de desarrollo full stack utilizando Firebase como Backend-as-a-Service.

---

## Descripción

La aplicación permite a los usuarios autenticarse, explorar un feed de imágenes, visualizar contenido detallado, subir imágenes y gestionar su perfil. Se trata de un MVP que prioriza la arquitectura, la organización del código y la integración de servicios.

---

## Tecnologías utilizadas

- Flutter / Dart  
- Firebase Authentication  
- Cloud Firestore  
- Firebase Storage  
- Arquitectura MVVM  

---

## Estructura del proyecto

```
lib
 ┣ services
 ┃ ┗ unsplash.dart
 ┣ views
 ┃ ┣ feed.dart
 ┃ ┣ login.dart
 ┃ ┣ pin.dart
 ┃ ┣ profile.dart
 ┃ ┣ register.dart
 ┃ ┣ search.dart
 ┃ ┗ upload_popup.dart
 ┣ widgets
 ┃ ┗ pin.dart
 ┣ auth_service.dart
 ┣ firebase_options.dart
 ┗ main.dart
```

---

## Funcionalidades

- Autenticación de usuarios mediante Firebase  
- Visualización de feed de imágenes  
- Búsqueda de contenido  
- Visualización de detalle de un pin  
- Subida de imágenes  
- Perfil de usuario  

---

## Arquitectura

El proyecto sigue el patrón MVVM (Model-View-ViewModel), permitiendo una separación clara entre la interfaz, la lógica de negocio y el acceso a datos. Firebase se utiliza como backend para simplificar la infraestructura y centrarse en la lógica de la aplicación.

---

## Modelo de datos

### users

```
{
  uid: string,
  name: string,
  email: string,
  photoUrl: string
}
```

### pins

```
{
  pinId: string,
  imageUrl: string,
  description: string,
  createdAt: timestamp,
  userId: string
}
```

---

## Instalación

### Clonar repositorio

```bash
git clone https://github.com/Marlene-Sanchez/pinterest.git
cd pinterest-clone
```

### Instalar dependencias

```bash
flutter pub get
```

### Configurar Firebase

- Crear proyecto en Firebase  
- Agregar archivos de configuración (Android/iOS)  
- Habilitar Authentication, Firestore y Storage  

### Ejecutar aplicación

```bash
flutter run
```

---

## Limitaciones

- No incluye sistema de recomendaciones  
- No incluye algoritmos de ranking  
- No incluye edición avanzada de imágenes  

---

## Mejoras futuras

- Sistema de likes y comentarios  
- Recomendaciones personalizadas  
- Notificaciones push  
- Soporte offline  

---

## Control de versiones

- main: versión estable  
- develop: integración de funcionalidades  
- feat: desarrollo de nuevas características  

---

## Autor

Marlene Tamara Sanchez Bautista
