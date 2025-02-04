# Media Files VS Static Files

## 1. **Definitions**

### **STATIC Files**
- **Purpose**: 
  - Used for files that do not change and are required site-wide, like CSS, JavaScript, and design images (e.g., logos or banners).
- **Location**: 
  - Typically stored in a `static/` directory.

### **MEDIA Files**
- **Purpose**: 
  - Used for user-uploaded files like profile pictures or documents.
- **Location**: 
  - Typically stored in a `media/` directory.

---

## 2. **Key Differences**

| Feature                     | **STATIC**                               | **MEDIA**                               |
|-----------------------------|------------------------------------------|-----------------------------------------|
| **Purpose**                 | Files required for the website's design or functionality. | Files uploaded by users.                |
| **Managed By**              | The developer during the project setup. | End-users during site usage.            |
| **Directory**               | Defined in the `STATICFILES_DIRS` or `STATIC_ROOT`. | Defined in the `MEDIA_ROOT`.            |
| **Access Path**             | Defined using `STATIC_URL`.             | Defined using `MEDIA_URL`.              |
| **Examples**                | CSS, JS, images for design.             | User profile pictures, documents, etc.  |

---

## 3. **Configuration in Django**

### **STATIC Configuration**
1. **Settings (`settings.py`)**:
```python
# URL for accessing static files
STATIC_URL = '/static/'

# Directory for static files during development
STATICFILES_DIRS = [
    BASE_DIR / "static",  # Example path
]

# Directory where static files will be collected (for production)
STATIC_ROOT = BASE_DIR / "staticfiles"
```

2. **URLs (`urls.py`)**:
   - During development, `STATIC_URL` automatically maps the static files. No additional URL configuration is needed.

3. **Usage in Templates**: 
   - Load and use static files with `{% static %}` in templates:

```html
<img src="{% static 'images/logo.png' %}" alt="Logo">
```

4. **Command for Production**:
   - Use the `collectstatic` management command to gather all static files into `STATIC_ROOT`

```bash
python manage.py collectstatic
```

---

### **MEDIA Configuration**
1. **Settings (`settings.py`)**:

```python
# URL for accessing media files
MEDIA_URL = '/media/'

# Directory to store uploaded media files
MEDIA_ROOT = BASE_DIR / "media"
```

2. **URLs (`urls.py`)**:
   - Add a URL pattern to serve media files during development

```python
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    # Your other URL patterns
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

3. **Usage in Templates**:
   - Access uploaded files using the `{{ object.file.url }}` template tag (or similar), ensuring you include `MEDIA_URL`:
```html
<img src="{{ user.profile_picture.url }}" alt="Profile Picture">
```

4. **Django Models for File Uploads**:
   - The `upload_to` argument determines where the file will be stored relative to `MEDIA_ROOT`.
```python
from django.db import models

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    profile_picture = models.ImageField(upload_to='profile_pics/')
```

---

## 4. **Development vs. Production**

### Development
- Django serves **STATIC** and **MEDIA** files using the `runserver` command by default.

### Production
- **STATIC** files should be served by a web server like **Nginx** or **Apache**.
- **MEDIA** files require stricter security settings to prevent unauthorized access.

#### Nginx configuration example:
```nginx
location /static/ {
    root /path/to/staticfiles/;
}

location /media/ {
    root /path/to/media/;
}
```

---

## 5. **Common Mistakes and Solutions**

| Issue                            | Cause                                          | Solution                                  |
| -------------------------------- | ---------------------------------------------- | ----------------------------------------- |
| **MEDIA files not loading**      | URL pattern for `MEDIA_URL` missing.           | Add `urlpatterns += static(...)`.         |
| **STATIC files not loading**     | Missing `collectstatic` command in production. | Run `collectstatic`.                      |
| **MEDIA file permissions issue** | Web server cannot access `MEDIA_ROOT`.         | Adjust file permissions or server config. |

---

By keeping **STATIC** and **MEDIA** files distinct, Django ensures clarity and security in handling site-wide assets and user-generated content.