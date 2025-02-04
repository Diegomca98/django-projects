# UserAdmin Class vs CustomUserAdmin

In Django, `UserAdmin` is a pre-built class provided by `django.contrib.auth.admin` that facilitates the management of the default User model in the Django admin panel. When using a custom *User model* (e.g., with additional fields), it's common to override or extend `UserAdmin` to customize its functionality.

## General Explanation

<details>
    <summary>Hide/Show Explanation</summary>

## Default `UserAdmin`
The `UserAdmin` class in `django.contrib.auth.admin` provides default configurations for managing users in the admin panel. It handles the following:
* Displaying a list of users with fields like username, email and more.
* Providing forms for creating and updating users.
* Managing permissions and groups

### Key Components of `UserAdmin`:
* `list_display`: Defines which fields are displayed in the admin list view.
* `search_fields`: Fields used for search functionality.
* `fieldsets`: Configures how fields are grouped and displayed in the user detail page.
* `add_fieldsets`: Configures fields displayed when adding a new user.

## Custom `UserAdmin`

When you define a custom User Model (e.g., adding fields like `profile_picture`, `phone_number`, etc.), you typically create a custom `UserAdmin` class to customize the admin interface. This involves:
* Extending `UserAdmin` to add or modify fields.
* Overriding the default behavior to support your custom User Model.

### Example: Custom `UserAdmin`
Here's an example of a custom `UserAdmin` for a `Customuser` model:

```python
###############################
###         models.py       ###
###############################
from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    phone_number = models.CharField(
        max_length = 15,
        blank = True,
        null = True
    )

##################################
###         admin.py           ###
##################################
from django.contrib import admin 
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser

class CustomUserAdmin(UserAdmin):
    ## Add custom fields to the list view
    list_display = (
        'username',
        'email',
        'first_name',
        'last_name',
        'is_staff',
        'phone_number'
    )
    # Allow searching by custom fields
    search_fields = (
        'username',
        'email',
        'phone_number'
    )

    fieldsets = UserAdmin.fieldsets + (
        (
            None,
            {
                'fields': (
                    'phone_number'
                )
            }
        ),
    )

    add_fieldsets = UserAdmin.add_fieldsets + (
        (
            None,
            {
                'fields': (
                    'phone_number'
                )
            }
        ),
    )

    admin.site.registe(CustomUser, CustomUserAdmin)
```

### How It Works
1. **Inheritance from** `UserAdmin`
   * By inheriting `UserAdmin`, you retain all the default functionality (e.g., group and permission management).
   * You add custom fields or modify behavior specific to your User model.

2. **Modifying Fields**
   * `list_display` includes your custom fields (e.g., `phone_number`).
   * `fieldsets` and `add_fieldsets` ensure the custom fields are displayed on the user detail and creation forms.

## Key Differences Between Default and Custom `UserAdmin`

| Feature          | Default `UserAdmin`               | Custom `UserAdmin`                  |
| ---------------- | --------------------------------- | ----------------------------------- |
| Fields Displayed | Default User fields only          | Includes additional custom fields   |
| Forms            | Handles default User model        | Adjusted for the custom User model  |
| Behavior         | Standard user management features | Tailored to the application's needs |
| Flexibility      | Limited to default fields         | Fully customizable                  |

### When to Extend UserAdmin:
* If you have a custom User model with additional fields.
* If you want to change how user fields are displayed or handled in the admin.
* If you need to customize search functionality, filtering, or user creation.

</details>


## Explanation on Video 24 from Section 7
<details>
    <summary>Hide/Show Explanation</summary>

<br>

In this case the main reason to add the adding the Custom User Admin was because the password was still editable from the Django Admin Panel, to change that behavior we added the `CustomUserAdmin` class to the `admin.py` as you can see in the next lines

### admin.py
```python
# admin.py
from django.contrib import admin
from .models import User

from django.contrib.auth.admin import UserAdmin

class CustomUserAdmin(UserAdmin):
    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()
    # You can use:
    # list_display = tuple() of all the attributes that we want to display in the admin
    # ordering = ('-date_joined') to order the users in a descending order according to the date_joined


admin.site.register(User)
```

1. `CustomUserAdmin` Class:

   * The `CustomUserAdmin` inherits from Django's `UserAdmin`. By doing so, you reuse much of the functionality of the default admin interface.

   * `filter_horizontal`, `list_filter`, and `fieldsets` are reset to empty tuples, effectively disabling these features unless customized.

   * There are additional attributes like `list_display` and `ordering` that can be added, but in this current setup, these features are not customized`.

2. Why `CustomUserAdmin`?:
 
   * Using `CustomUserAdmin` allows you to extend or modify how the user is displayed in the admin interface, but currently, your implementation makes only minimal changes (i.e., resetting certain options).

### Why the Password Became Non-Editable in the Admin

The reason the password is now non-editable after registering the CustomUserAdmin lies in the default behavior of Django's UserAdmin class and how the AbstractBaseUser works. Here's the explanation:

1. Default Behavior of `UserAdmin`:

The default UserAdmin in Django hides the password field in the admin interface. Instead of displaying or allowing edits, it provides a "Password" link to change the password via Django’s secure password reset/change mechanism.

2. The **CustomUserAdmin**:

By inheriting from `UserAdmin` without modifying the behavior related to the password field, you retain this default behavior. Django assumes that the `User` model is still password-sensitive and ensures the password is never exposed or directly editable in the admin.

3. Why It Was Editable Before:

Before creating `CustomUserAdmin`, you had not overridden the admin behavior for your custom `User` model. This means the User was treated as a generic model, and all fields (including `password`) were editable in the admin panel by default.

4. What Changed:
   
Registering `CustomUserAdmin` ties your custom User model to `UserAdmin`. Since `UserAdmin` treats `password` as a sensitive field, it prevents direct editing of passwords to enhance security.

5. Password Reset in Admin:

If you want to change a user's password in the admin panel, you can do so via the *"Change password"* form linked from the user’s detail view. This ensures the password is hashed properly.


</details>

## Conclusion on the Use Case in this project

1. Summary of Changes:

   * The password field became non-editable because you tied your custom `User` model to Django’s secure `UserAdmin` behavior by registering `CustomUserAdmin`. This is a security feature to prevent accidental exposure of raw passwords.

2. Suggestions for Password Management:

   * If you ever need to override this behavior (e.g., to allow manual password setting), you can customize the `form` class for your `CustomUserAdmin` or create a custom fieldset (**HOWEVER THIS IS NOT RECOMMENDED FOR SECURITY REASONS**):

```python
class CustomUserAdmin(UserAdmin):
    fieldsets = (
        (None, {'fields': ('email', 'username', 'password')}),
        # Other sections...
    )
```

3. Final Thoughts:
   * The change is a result of inheriting from `UserAdmin`, and no further modifications are needed unless you have specific customization requirements.
