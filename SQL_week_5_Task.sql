-- Drop tables if they already exist
DROP TABLE IF EXISTS SubjectRequest;
DROP TABLE IF EXISTS SubjectAllotments;

-- Create SubjectAllotments table
CREATE TABLE SubjectAllotments (
    StudentID VARCHAR(50),
    SubjectID VARCHAR(50),
    Is_valid BIT
);

-- Create SubjectRequest table
CREATE TABLE SubjectRequest (
    StudentID VARCHAR(50),
    SubjectID VARCHAR(50)
);


-- Initial data for SubjectAllotments (before request)
INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_valid) VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

-- Insert request (new subject requested)
INSERT INTO SubjectRequest (StudentID, SubjectID) VALUES
('159103036', 'PO1496');



CREATE PROCEDURE UpdateSubjectAllotments
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentID VARCHAR(50);
    DECLARE @RequestedSubjectID VARCHAR(50);
    DECLARE @CurrentSubjectID VARCHAR(50);

    DECLARE cur CURSOR FOR
        SELECT StudentID, SubjectID FROM SubjectRequest;

    OPEN cur;
    FETCH NEXT FROM cur INTO @StudentID, @RequestedSubjectID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get current valid subject
        SELECT @CurrentSubjectID = SubjectID
        FROM SubjectAllotments
        WHERE StudentID = @StudentID AND Is_valid = 1;

        -- If the requested subject is already present
        IF EXISTS (
            SELECT 1 FROM SubjectAllotments
            WHERE StudentID = @StudentID AND SubjectID = @RequestedSubjectID
        )
        BEGIN
            -- If it's different from current, update
            IF @RequestedSubjectID != @CurrentSubjectID
            BEGIN
                -- Mark current as invalid
                UPDATE SubjectAllotments
                SET Is_valid = 0
                WHERE StudentID = @StudentID AND SubjectID = @CurrentSubjectID;

                -- Insert requested subject as valid
                INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_valid)
                VALUES (@StudentID, @RequestedSubjectID, 1);
            END
            -- If same, do nothing
        END
        ELSE
        BEGIN
            -- Insert new subject as valid
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_valid)
            VALUES (@StudentID, @RequestedSubjectID, 1);

            -- Invalidate current if any
            IF @CurrentSubjectID IS NOT NULL
            BEGIN
                UPDATE SubjectAllotments
                SET Is_valid = 0
                WHERE StudentID = @StudentID AND SubjectID = @CurrentSubjectID;
            END
        END

        FETCH NEXT FROM cur INTO @StudentID, @RequestedSubjectID;
    END

    CLOSE cur;
    DEALLOCATE cur;
END;


EXEC UpdateSubjectAllotments;

-- View final state of SubjectAllotments
SELECT * FROM SubjectAllotments ORDER BY Is_valid DESC;