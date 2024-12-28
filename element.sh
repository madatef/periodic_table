#!/bin/bash

# Set PSQL command with username
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo Please provide an element as an argument.
  exit 0
fi

# Query the database to fetch element information
ELEMENT_INFO=$($PSQL "
  SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
  FROM elements AS e
  JOIN properties AS p ON e.atomic_number = p.atomic_number
  JOIN types AS t ON p.type_id = t.type_id
  WHERE e.atomic_number::TEXT = '$1' OR e.symbol = '$1' OR e.name = '$1';
")

# Check if the element was found
if [[ -z $ELEMENT_INFO ]]; then
  echo "I could not find that element in the database."
  exit 0
fi


# Parse the result into variables
IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_INFO"

# Print the formatted message
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
