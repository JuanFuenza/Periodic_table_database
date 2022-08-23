#!/bin/bash
# Script that takes an input of an element and returns information about it from the periodic table database.

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if script dont get an argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check if input is numeric
  if [[ $1 =~ [0-9]+ ]]
  then
    # check if atomic number in database
    NUMERIC=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    # if atomic number is null
    if [[ -z $NUMERIC ]]
    then
      echo "I could not find that element in the database."
    else
      # get name of the element
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      # get symbol of the element
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
      # get type by type ID
      TYPE_NAME=$($PSQL "SELECT type FROM types FULL JOIN properties USING(type_id) WHERE atomic_number=$1")
      # get mass of the element
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
      # get melting point in celsius
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
      # get boiling point in celsius
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
      # display info of the element
      echo "The element with atomic number $1 is $(echo $NAME | sed 's/ |/"/') ($(echo $SYMBOL | sed 's/ |/"/')). It's a $(echo $TYPE_NAME | sed 's/ |/"/'), with a mass of $(echo $MASS | sed 's/ |/"/') amu. $(echo $NAME | sed 's/ |/"/') has a melting point of $(echo $MELTING_POINT | sed 's/ |/"/') celsius and a boiling point of $(echo $BOILING_POINT | sed 's/ |/"/') celsius."
     fi
  else
  # if not numeric get symbol
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1' or name='$1'")
    if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      # get atomic number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' or name='$1'")
      # get name of the element
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      # get symbol of the element
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      # get type by type ID
      TYPE_NAME=$($PSQL "SELECT type FROM types FULL JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      # get mass of the element
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      # get melting point in celsius
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      # get boiling point in celsius
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      # display info of the element
      echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed 's/ |/"/') is $(echo $NAME | sed 's/ |/"/') ($(echo $SYMBOL | sed 's/ |/"/')). It's a $(echo $TYPE_NAME | sed 's/ |/"/'), with a mass of $(echo $MASS | sed 's/ |/"/') amu. $(echo $NAME | sed 's/ |/"/') has a melting point of $(echo $MELTING_POINT | sed 's/ |/"/') celsius and a boiling point of $(echo $BOILING_POINT | sed 's/ |/"/') celsius."
    fi
  fi
fi
