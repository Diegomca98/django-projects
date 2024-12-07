# BaseUserManager for Custom User Creation

The BaseUserManager is fundamentally the SAME in both scenarios (either using `AbstractBaseUser` and `AbstractUser`). The implementation details and extent of customization may vary, but the core inheritance and method structure remain consistent.

## BaseUserManager with AbstractBaseUser
When using `AbstractBaseUser`, you **MUST** create a custom **UserManager** that inherits from `BaseUserManager`. This is because `AbstractBaseUser` provides a completely blank slate, so you need to define all authentication methods.

**Example:**
```python
from django.contrib.auth.models import BaseUserManager

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Users must have an email address')
        
        user = self.model(
            email=self.normalize_email(email),
            **extra_fields
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        return self.create_user(email, password, **extra_fields)
```

## BaseUserManager with AbstractUser
When using `AbstractUser`, you can still customize the **UserManager**, but it's not as critically necessary. Django provides more built-in functionality.

**Example:**
```python 
from django.contrib.auth.models import AbstractUser, BaseUserManager

class CustomUserManager(BaseUserManager):
    # Often, you can use the default implementation
    # But you might add custom methods if needed
    def create_user(self, username, email, password=None, **extra_fields):
        # More straightforward implementation
        extra_fields.setdefault('is_active', True)
        return super().create_user(username, email, password, **extra_fields)
```

## Key Differences

1. AbstractBaseUser
   * Requires a fully custom UserManager
   * Must implement all core methods
   * More manual work
   * Complete flexibility

2. AbstractUser
   * Can use a minimal custom UserManager
   * Many methods already implemented
   * Less manual work
   * Moderate flexibility

## Inheritance Similarities

The BaseUserManager is essentially the **SAME** in both cases:

* It provides core methods like `normalize_email()`
* It defines the structure for `create_user()` and `create_superuser()`
* The main difference is in how thoroughly you need to implement these methods

## Practical Recommendation
* For **AbstractBaseUser**: Fully implement both `create_user()` and `create_superuser()`
* For **AbstractUser**: You can often use the default implementation or make minimal customizations


## Code Demo
```python
# Works similarly in both cases
class MyUserManager(BaseUserManager):
    def create_user(self, identifier, password=None, **extra_fields):
        # The core logic remains consistent
        user = self.model(identifier, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
```

## Best Practices
1. Always inherit from ***BaseUserManager***
2. Implement `create_user()` and `create_superuser()`
3. Use `self.normalize_email()` for email fields
4. Set default values for important fields
5. Use `set_password()` for secure password handling