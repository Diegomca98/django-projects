# AbstractBaseUser vs AbstractUser

**Recomendación General**: Si no tienes requisitos específicos complejos, AbstractUser es generalmente más simple y rápido de implementar.

## AbstractBaseUser

1. Abstraction Level

   * A completely "bare" base for creating user models
   * No default fields included
   * You must define ALL necessary fields

2. Customization

   * Offers maximum flexibility
   * You must implement ALL methods and fields
   * You need to explicitly define:
     * User fields
     * User manager
     * Authentication methods
   
3. Implementation Example

```python
class MyUser(AbstractBaseUser):
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=100)
    is_active = models.BooleanField(default=True)

    # Additional fields and configurations
    USERNAME_FIELD = 'email'  # Use email for login
    REQUIRED_FIELDS = ['username']

    objects = MyUserManager()
```

## AbstractUser

1. Abstraction Level
   * A "pre-configured" version of the user model
   * Includes default Django fields
   * List of **included** fields:
     * username
     * first_name
     * last_name
     * email
     * is_staff
     * is_active
     * date_joined
     * is_superuser 

2. Customization
   * Less initial work
   * You can easily add fields
   * Authentication methods already implemented

3. Implementation Example
```python
class MyUser(AbstractUser):
    # Additional fields
    phone = models.CharField(max_length=15)
    birth_date = models.DateField(null=True)
```

## Direct Comparison

| Characteristic      | AbstractBaseUser          | AbstractUser                      |
| ------------------- | ------------------------- | --------------------------------- |
| Predefined Fields   | None                      | Multiple Fields                   |
| Implementation Work | High                      | Low                               |
| Flexibility         | Maximum                   | Moderate                          |
| Setup Complexity    | High                      | Low                               |
| Ideal For           | Completely custom systems | Systems with slight modifications |

## When to Use Each

   * AbstractBaseUser:

     * Need a completely custom user model
     * Default model doesn't fit your requirements
     * Want full control over authentication

   * AbstractUser:

     * Need to add a few fields
     * Default model is almost perfect
     * Want a quick setup with moderate flexibility



## Important Consideration
In both cases, you must define a custom **UserManager** ([BaseUserManager](BASE_USER_MANAGER.MD)) to handle user creation.