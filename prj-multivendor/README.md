# Python Django - Build Complex MultiVendor Ecommerce System

> [!NOTE]
> Branch: Development

This is a multivendor Ecommerce project that uses django, geodjango and some integrations with Google APIs.

<details>
<summary>Project Flowchart</summary>

![Project Flowchart](./documentation/images/foodOnline-Flowchart.svg)

</details>

## Section 6: Custom User Model, Media Files & Django Signals

### 23. Custom User Model

To create a Custom User Model in Django we can do the following:

* Create a new User model that inherits from either `AbstractBaseUser` or `AbstractUser` class, which are imported from `django.contrib.auth.models`, depending on what you want to do, here's an explanation on the difference between both inherited classes. [Creating Custom User Models](./documentation/docs/CUSTOM_USR_INHERITANCE.MD)
* When creating a Custom User Model you too need to use a [Custom User Manager](./documentation/docs/BASE_USER_MANAGER.MD)


### 24. Make Password Noneditable

When creating a custom user model we will have to add certain rules to avoid the password being editable from the **Django Admin Panel**.

* In our `admin.py`
  1. `from django.contrib.auth.admin import UserAdmin`
  2. Create a class `CustomUserAdmin(UserAdmin)`
  3. For more information and detail click here: [CustomUserAdmin](/documentation/docs/USER_ADMIN.MD)

### 27. Media Files Configuration

The configurations of media files and static files are independent from one another, to check the difference and more info about both click here: [Media VS Static](./documentation/docs/IMAGES.MD)

### 28. Django Signals to Create User Profile

To learn more about Django Signals click here: [Django Signals](./documentation/docs/DJANGO_SIGNALS.MD)