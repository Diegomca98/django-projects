#! /bin/bash

echo "What operation would you like to do?"
echo "1. Start the Development Environment"
echo "2. Remove Containers from Development Environment"
echo "3. Completely remove service (Containers, Volumes and Images)"
read -p "Type the number of the process you want to run: "  process

if [ $process -eq "1" ]
then
    # Start development environment
    docker-compose up -d --build

    # > Run python commands
    ##  | Make Migrations
    ##  | Create Superuser
    docker-compose run web python manage.py flush --no-input  # WARNING: Deletes all data
    docker-compose run web python manage.py makemigrations
    docker-compose run web python manage.py migrate
    docker-compose exec web python manage.py createsuperuser
    
elif [ $process -eq "2" ]
then
    docker-compose down

else
    # Stop and remove everything, including volumes and images
    docker-compose down --rmi all --volumes --remove-orphans

    # Manually remove any lingering named volumes (optional)
    docker volume rm django-projects_postgres_data || true

    # Prune any remaining unused volumes
    docker volume prune -f

fi