from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import User, UserProfile

class CustomUserAdmin(UserAdmin):
    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()

    # You can also use:
    # list_display = tuple() of all the attributes that we want to display in the admin
    # ordering = ('-date_joined') to order the users in a descending order according to the date_joined


admin.site.register(User)
admin.site.register(UserProfile)