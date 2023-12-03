-- Triggers to update average user_rating value based on the new rating submitted by the user

-- Insert trigger
delimiter //
Create Trigger UpdateAvgRating
After Insert ON user_ratings
FOR EACH ROW
BEGIN
SET @old_average = (SELECT user_rating FROM airlines WHERE IATA_CODE = NEW.IATA_CODE);

SET @review_count = (SELECT COUNT(*) FROM user_ratings WHERE IATA_CODE = NEW.IATA_CODE);

SET @new_average = ((@old_average * (@review_count - 1)) + NEW.rating)/(@review_count);

IF @new_average <> @old_average THEN
	UPDATE airlines SET user_rating = @new_average
	WHERE IATA_CODE = New.IATA_CODE;
END IF;
END; //
delimiter ;


-- Update trigger
delimiter //

Create Trigger ModifyAvgRating
After UPDATE ON user_ratings
FOR EACH ROW
BEGIN
SET @old_average = (SELECT user_rating FROM airlines WHERE IATA_CODE = NEW.IATA_CODE);

SET @review_count = (SELECT COUNT(*) FROM user_ratings WHERE IATA_CODE = NEW.IATA_CODE);

SET @new_average = ((@old_average * @review_count) + NEW.rating - OLD.rating)/(@review_count);

IF @new_average <> @old_average THEN
	UPDATE airlines SET user_rating = @new_average
	WHERE IATA_CODE = New.IATA_CODE;
END IF;
END; //
delimiter ;


-- Delete trigger

DELIMITER //

CREATE TRIGGER DeleteRating
AFTER DELETE ON user_ratings
FOR EACH ROW
BEGIN
    SET @old_average = (SELECT user_rating FROM airlines WHERE IATA_CODE = OLD.IATA_CODE);
    SET @review_count = (SELECT COUNT(*) FROM user_ratings WHERE IATA_CODE = OLD.IATA_CODE);

    IF @review_count = 0 THEN
        SET @new_average = 0;
    ELSE
        SET @new_average = ((@old_average * (@review_count + 1)) - OLD.rating) / @review_count;
    END IF;

    IF @new_average <> @old_average THEN
        UPDATE airlines SET user_rating = @new_average WHERE IATA_CODE = OLD.IATA_CODE;
    END IF;
END;

//
DELIMITER ;
