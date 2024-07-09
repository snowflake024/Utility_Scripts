<?php
// Check if the required arguments are provided
if ($argc !== 6) {
    die("Usage: php test_db_connection.php <servername> <username> <password> <dbname> <query>\n");
}

// Get the arguments
$servername = $argv[1];
$username = $argv[2];
$password = $argv[3];
$dbname = $argv[4];
$query = $argv[5];

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error . "\n");
}
echo "Connected successfully\n";

// Perform the query
$result = $conn->query($query);

if ($result === FALSE) {
    echo "Error: " . $conn->error . "\n";
} elseif ($result->num_rows > 0) {
    // Output data of each row
    while ($row = $result->fetch_assoc()) {
        echo json_encode($row) . "\n";
    }
} else {
    echo "0 results\n";
}

// Close connection
$conn->close();
?>
