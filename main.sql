CREATE TABLE Files (
    FileID INT PRIMARY KEY,
    FileName VARCHAR(255),
    FileData BLOB,
    CompressedData BLOB
);

CREATE TABLE CompressionHistory (
    CompressionID INT PRIMARY KEY,
    FileID INT,
    CompressionDate DATE,
    CompressionRatio DECIMAL(10, 2),
    FOREIGN KEY (FileID) REFERENCES Files(FileID)
);

CREATE PROCEDURE CompressFile(
    @FileID INT,
    @CompressionLevel INT
)
BEGIN
    DECLARE @CompressedData BLOB;
    DECLARE @CompressionRatio DECIMAL(10, 2);
    SET @CompressedData = COMPRESS(FileData, @CompressionLevel);
    SET @CompressionRatio = (DATALENGTH(FileData) - DATALENGTH(@CompressedData)) / DATALENGTH(FileData) * 100;
    INSERT INTO CompressionHistory (FileID, CompressionDate, CompressionRatio) VALUES (@FileID, GETDATE(), @CompressionRatio);
    UPDATE Files SET CompressedData = @CompressedData WHERE FileID = @FileID;
END;

CREATE FUNCTION GetCompressionRatio(
    @FileID INT
)
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE @CompressionRatio DECIMAL(10, 2);
    SELECT @CompressionRatio = CompressionRatio FROM CompressionHistory WHERE FileID = @FileID ORDER BY CompressionDate DESC LIMIT 1;
    RETURN @CompressionRatio;
END;

CREATE VIEW CompressedFiles AS
SELECT F.FileID, F.FileName, F.CompressedData, CH.CompressionRatio
FROM Files F
JOIN CompressionHistory CH ON F.FileID = CH.FileID
ORDER BY CH.CompressionDate DESC;

INSERT INTO Files (FileID, FileName, FileData) VALUES
(1, 'File1.txt', CONVERT(BLOB, 'Hello World!')),
(2, 'File2.txt', CONVERT(BLOB, 'This is a test file.')),
(3, 'File3.txt', CONVERT(BLOB, 'Compression test file.'));

EXEC CompressFile 1, 6;
EXEC CompressFile 2, 8;
EXEC CompressFile 3, 5;

SELECT * FROM CompressedFiles;
SELECT * FROM CompressionHistory;
SELECT * FROM Files;