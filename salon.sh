#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED


  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED" 2>/dev/null)

  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU
  else
    echo "What's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo "What's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi

    echo "What time would you like your appointment?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    CUSTOMER_NAME_DB=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    CLEAN_NAME=$(echo $CUSTOMER_NAME_DB)
    CLEAN_SERVICE=$(echo $SERVICE_NAME)

    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    echo "I have put you down for a $CLEAN_SERVICE at $SERVICE_TIME, $CLEAN_NAME."
  fi
}

MAIN_MENU
