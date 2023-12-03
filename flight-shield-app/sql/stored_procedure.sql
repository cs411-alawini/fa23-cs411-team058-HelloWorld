-- For the static pie chart, calculates the pie chart angles and airlines names for the angles
DELIMITER //

CREATE PROCEDURE GetAirlineDelays()
BEGIN
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE airline_name VARCHAR(255);
    DECLARE avg_departure_delay FLOAT;
    DECLARE total_delay FLOAT;
    DECLARE delay_percentage FLOAT;
    DECLARE pie_chart_angle FLOAT;

    
    DECLARE cur1 CURSOR FOR 
        SELECT a.AIRLINE, AVG(d.DEPARTURE_DELAY) AS Avg_Delay
        FROM delays d
        JOIN airlines a ON d.AIRLINE = a.IATA_CODE
        GROUP BY a.AIRLINE
        ORDER BY Avg_Delay DESC
        LIMIT 5;

   
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DROP TEMPORARY TABLE IF EXISTS PieChartAngles;
    CREATE TEMPORARY TABLE PieChartAngles (angle FLOAT);

    
    SELECT SUM(Avg_Delay) INTO total_delay
FROM (
	SELECT AVG(d.DEPARTURE_DELAY) AS Avg_Delay
	FROM delays d
	JOIN airlines a ON d.AIRLINE = a.IATA_CODE
	GROUP BY a.AIRLINE
	ORDER BY Avg_Delay DESC
	LIMIT 5
) AS Subquery;

    -- Open the cursor, fetch rows from it, and process each row
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO airline_name, avg_departure_delay;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
    
        SET delay_percentage = (avg_departure_delay / total_delay) * 100;
        SET pie_chart_angle = delay_percentage * 3.6;

        
        INSERT INTO PieChartAngles VALUES (pie_chart_angle);

        
        -- INSERT INTO some_result_table VALUES (airline_name, avg_departure_delay, delay_percentage, pie_chart_angle);
    END LOOP;
    CLOSE cur1;

    
    SELECT GROUP_CONCAT(angle ORDER BY angle DESC SEPARATOR ',') AS PieChartAnglesArray
    FROM PieChartAngles;

END;

//
DELIMITER ;

-- For the Risk Meter, calculates total average delay and assigns a risk level L1-L7 based on delay value

DELIMITER //

CREATE PROCEDURE GetAvgDelayWithRisk(
    IN originAirportCode VARCHAR(3),
    IN destinationAirportCode VARCHAR(3),
    IN flightDate VARCHAR(255)
)
BEGIN
    SELECT 
        SUM(d.DEPARTURE_DELAY) AS Avg_Delay,
        CASE
  WHEN SUM(d.DEPARTURE_DELAY) < 0 THEN 'L1'
            WHEN SUM(d.DEPARTURE_DELAY) BETWEEN 0 AND 1 THEN 'L1'
            WHEN SUM(d.DEPARTURE_DELAY) BETWEEN 1 AND 2 THEN 'L2'
            WHEN SUM(d.DEPARTURE_DELAY) BETWEEN 2 AND 3 THEN 'L3'
            WHEN SUM(d.DEPARTURE_DELAY) BETWEEN 3 AND 4 THEN 'L4'
            WHEN SUM(d.DEPARTURE_DELAY) BETWEEN 4 AND 5 THEN 'L5'
            WHEN SUM(d.DEPARTURE_DELAY) BETWEEN 5 AND 6 THEN 'L6'
            WHEN SUM(d.DEPARTURE_DELAY) > 6 THEN 'L7'
            ELSE 'Unknown'
        END AS Risk_Level
    FROM delays d
    JOIN flights f ON d.DATE = f.DATE AND d.AIRLINE = f.AIRLINE AND d.FLIGHT_NUMBER = f.FLIGHT_NUMBER
    JOIN airlines a ON a.IATA_CODE = f.AIRLINE
    WHERE f.ORIGIN_AIRPORT = originAirportCode
    AND f.DESTINATION_AIRPORT = destinationAirportCode
    AND f.DATE = flightDate;
END;

//
DELIMITER ;
CALL GetAvgDelayWithRisk('JFK', 'SFO', '1-Jan');


-- Prints top 2 rated airlines for the given route

DELIMITER //

CREATE PROCEDURE GetTopRatedAirlines(
    IN origin VARCHAR(255),
    IN destination VARCHAR(255),
    IN date VARCHAR(255),
    OUT airline_name1 VARCHAR(255),
    OUT rating_val1 INT,
    OUT airline_name2 VARCHAR(255),
    OUT rating_val2 INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_airline_name VARCHAR(255);
    DECLARE cur_rating_val INT;

    DECLARE cur CURSOR FOR
        SELECT DISTINCT a.AIRLINE, a.user_rating * 10 AS rating
        FROM airlines a
        JOIN flights f ON a.IATA_CODE = f.AIRLINE
        WHERE f.ORIGIN_AIRPORT = origin
        AND f.DESTINATION_AIRPORT = destination
        AND f.DATE = date
        ORDER BY rating DESC
        LIMIT 2;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO airline_name1, rating_val1;
        IF done THEN
            LEAVE read_loop;
        END IF;
	   
        FETCH cur INTO airline_name2, rating_val2;

    END LOOP read_loop;

    CLOSE cur;
END;

//
DELIMITER ;


CALL GetTopRatedAirlines('JFK', 'SFO', '1-Jan', @airline_name1, @rating_val1, @airline_name2, @rating_val2);

SELECT @airline_name1, @rating_val1;
SELECT @airline_name2, @rating_val2;
