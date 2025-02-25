# Cinema Database

This project involves the creation of a PostgreSQL database for managing a cinema system. The database is designed to handle various aspects of a cinema, including cinema halls, films, screenings, seats, users, and tickets. The schema includes custom enumerated types, tables, and relationships to ensure data integrity and efficient querying.

## Database Schema

### Custom Enumerated Types
- **`screening_status_enum`**: Represents the status of a screening (`available`, `unavailable`).
- **`ticket_status_enum`**: Represents the status of a ticket (`active`, `inactive`, `refunded`).
- **`day_enum`**: Represents days of the week (`sat`, `sun`, `mon`, `tue`, `wed`, `thu`, `fri`).
- **`genre_enum`**: Represents film genres (`romance`, `action`, `horror`, `comedy`, `drama`, `fiction`, `documentry`, `musical`, `western`, `historical`, `biography`).

### Tables
1. **`cinema`**: Stores information about cinemas.
   - Columns: `cinema_id`, `name`, `location`, `address`, `city`, `ticket_price`.
   - Constraints: Primary key on `cinema_id`.

2. **`hall`**: Stores information about cinema halls.
   - Columns: `hall_id`, `cinema_id`, `number`, `name`, `map_url`, `capacity`, `utilities`.
   - Constraints: Foreign key to `cinema`, unique constraint on `cinema_id` and `number`.

3. **`film`**: Stores information about films.
   - Columns: `film_id`, `name`, `genre`, `release_date`, `director`, `writer`, `producer`, `description`.
   - Constraints: Primary key on `film_id`.

4. **`screening`**: Stores information about film screenings.
   - Columns: `screening_id`, `film_id`, `hall_id`, `status`, `from_date`, `to_date`, `from_hour`, `to_hour`, `days`.
   - Constraints: Foreign keys to `film` and `hall`.

5. **`seat`**: Stores information about seats in a hall.
   - Columns: `row_number`, `col_number`, `hall_id`, `is_vip`, `position`.
   - Constraints: Composite primary key on `row_number`, `col_number`, and `hall_id`; foreign key to `hall`.

6. **`cinema_user`**: Stores information about cinema users.
   - Columns: `username`, `phone_number`, `email`, `name`, `national_number`.
   - Constraints: Primary key on `username`; unique constraints on `phone_number`, `email`, and `national_number`; format checks for `phone_number`, `email`, and `national_number`.

7. **`ticket`**: Stores information about tickets.
   - Columns: `screening_id`, `user_id`, `seat_row_number`, `seat_col_number`, `seat_hall_id`, `ticket_date`, `price`, `status`.
   - Constraints: Foreign keys to `screening`, `cinema_user`, and `seat`.

### Sample Data
The database is pre-populated with sample data for testing and demonstration purposes:
- **Cinemas**: Two cinemas (`Grand Cinema`, `City Lights`).
- **Halls**: Three halls across the two cinemas.
- **Films**: Two films (`Love in the Air`, `Epic Battle`).
- **Screenings**: Two screenings for the films.
- **Seats**: Three seats in one hall.
- **Users**: Two users (`user1`, `user2`).
- **Tickets**: Two tickets for the screenings.



### Steps to Set Up the Database
1. **Create the Database**:
   ```sql
   CREATE DATABASE cinema_database;
   ```

2. **Run the Schema Script**:
   - Execute the provided SQL script to create the tables, types, and relationships.

3. **Insert Sample Data**:
   - Run the `INSERT` statements to populate the database with sample data.

4. **Query the Database**:
   - Use SQL queries to interact with the database. For example:
     ```sql
     SELECT * FROM cinema;
     SELECT * FROM film WHERE 'romance' = ANY(genre);
     SELECT * FROM ticket WHERE status = 'active';
     ```

### Example Queries
- **Find all available screenings**:
  ```sql
  SELECT * FROM screening WHERE status = 'available';
  ```

- **Find all tickets for a specific user**:
  ```sql
  SELECT * FROM ticket WHERE user_id = 'user1';
  ```

- **Find all VIP seats in a hall**:
  ```sql
  SELECT * FROM seat WHERE hall_id = 1 AND is_vip = TRUE;
  ```

## Notes
- **Data Integrity**: Foreign key constraints ensure that related records are not orphaned.
- **Custom Types**: Enumerated types (`ENUM`) are used to restrict certain columns to predefined values.
- **Sample Data**: The provided sample data can be modified or extended for testing purposes.
