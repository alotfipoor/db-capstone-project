-- Exercise: Create SQL queries to check available bookings based on user input
-- Task 1

INSERT INTO `LittleLemonDB`.`Bookings` (`BookingID`, `Date`, `TableNumber`, `CustomerID`, `StaffID`) VALUES
(11, '2022-10-10', 5, 1, 1),
(12, '2022-11-12', 3, 3, 2),
(13, '2022-10-11', 2, 2, 3),
(14, '2022-10-13', 2, 1, 1);

-- Task 2
DELIMITER //
CREATE PROCEDURE `LittleLemonDB`.`CheckBooking`(IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE table_status VARCHAR(50);

    SELECT COUNT(*) INTO @table_count
    FROM `LittleLemonDB`.`Bookings`
    WHERE `Date` = booking_date AND `TableNumber` = table_number;

    IF (@table_count > 0) THEN
        SET table_status = 'Table is already booked.';
    ELSE
        SET table_status = 'Table is available.';
    END IF;

    SELECT table_status AS 'Table Status';
END;
//
DELIMITER ;
CALL `LittleLemonDB`.`CheckBooking`('2022-10-10', 5);

-- Task 3

DELIMITER //
CREATE PROCEDURE `LittleLemonDB`.`AddValidBooking`(IN new_booking_date DATE, IN new_table_number INT, IN new_customer_id INT, IN new_staff_id INT)
BEGIN
    DECLARE table_status INT;
    START TRANSACTION;

    SELECT COUNT(*) INTO table_status
    FROM `LittleLemonDB`.`Bookings`
    WHERE `Date` = new_booking_date AND `TableNumber` = new_table_number;

    IF (table_status > 0) THEN
        ROLLBACK;
        SELECT 'Booking could not be completed. Table is already booked on the specified date.' AS 'Status';
    ELSE
        INSERT INTO `LittleLemonDB`.`Bookings`(`Date`, `TableNumber`, `CustomerID`, `StaffID`)
        VALUES(new_booking_date, new_table_number, new_customer_id, new_staff_id);

        COMMIT;
        SELECT 'Booking completed successfully.' AS 'Status';
    END IF;
END;
//
DELIMITER ;

CALL `LittleLemonDB`.`AddValidBooking`('2022-10-10', 5, 1, 1);

-- Exercise: Create SQL queries to add and update bookings
-- Task 1

DELIMITER //
CREATE PROCEDURE `LittleLemonDB`.`AddBooking`(
    IN new_booking_id INT, 
    IN new_customer_id INT, 
    IN new_booking_date DATE, 
    IN new_table_number INT, 
    IN new_staff_id INT)
BEGIN
    -- Insert the new booking record
    INSERT INTO `LittleLemonDB`.`Bookings`(
        `BookingID`, 
        `CustomerID`, 
        `Date`, 
        `TableNumber`, 
        `StaffID`)
    VALUES(
        new_booking_id, 
        new_customer_id, 
        new_booking_date, 
        new_table_number,
        new_staff_id
    );

    SELECT 'New booking added' AS 'Confirmation';
END;
//
DELIMITER ;


CALL `LittleLemonDB`.`AddBooking`(17, 1, '2022-10-10', 5, 2);

-- Task 2

DELIMITER //
CREATE PROCEDURE `LittleLemonDB`.`UpdateBooking`(
    IN booking_id_to_update INT, 
    IN new_booking_date DATE)
BEGIN
    -- Update the booking record
    UPDATE `LittleLemonDB`.`Bookings`
    SET `Date` = new_booking_date
    WHERE `BookingID` = booking_id_to_update;

    SELECT CONCAT('Booking ', booking_id_to_update, ' updated') AS 'Confirmation';
END;
//
DELIMITER ;

CALL `LittleLemonDB`.`UpdateBooking`(9, '2022-11-15');

-- Task 3

DELIMITER //
CREATE PROCEDURE `LittleLemonDB`.`CancelBooking`(IN booking_id_to_cancel INT)
BEGIN
    -- Delete the booking record
    DELETE FROM `LittleLemonDB`.`Bookings`
    WHERE `BookingID` = booking_id_to_cancel;

    SELECT CONCAT('Booking ', booking_id_to_cancel, ' cancelled') AS 'Confirmation';
END;
//
DELIMITER ;

CALL `LittleLemonDB`.`CancelBooking`(9);