<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Leer usuarios del archivo JSON
$usersFile = __DIR__ . '/users.json';

if (!file_exists($usersFile)) {
    echo json_encode([
        'success' => false,
        'message' => 'Archivo de usuarios no encontrado'
    ]);
    exit;
}

$usersData = json_decode(file_get_contents($usersFile), true);

// Obtener datos del POST
$input = json_decode(file_get_contents('php://input'), true);
$username = $input['username'] ?? '';
$password = $input['password'] ?? '';

// Validar credenciales
$authenticated = false;
$userName = '';

foreach ($usersData['users'] as $user) {
    if ($user['username'] === $username && $user['password'] === $password) {
        $authenticated = true;
        $userName = $user['name'];
        break;
    }
}

if ($authenticated) {
    echo json_encode([
        'success' => true,
        'message' => 'Autenticación exitosa',
        'name' => $userName
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Usuario o contraseña incorrectos'
    ]);
}
?>
