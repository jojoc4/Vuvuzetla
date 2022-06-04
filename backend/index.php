<?php

require 'config.php';
require 'models/messages.php';
require 'models/actions.php';
require 'controllers/messagesController.php';
require 'controllers/actionController.php';


//router
switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        if (isset($_GET['r'])) {
            header("Content-Type: application/json");
            switch ($_GET['r']) {
                case 'messages':
                    echo messagesController::getMessages($_GET);
                    break;
            }
        } else if (isset($_GET['a']) && $_GET['a'] == "lacensure") {
            if (isset($_GET['d'])) {
                switch ($_GET['d']) {
                    case 'c':
                        messagesController::censor($_GET);
                        break;
                    case 'd':
                        messagesController::delete($_GET);
                        break;
                    case 'du':
                        messagesController::deleteUser($_GET);
                        break;
                }
            }
            require 'views/map.php';
        } else {
            require 'views/index.html';
        }
        break;
    case 'POST':
        if (isset($_GET['r'])) {
            header("Content-Type: application/json");
            switch ($_GET['r']) {
                case 'messages':
                    echo messagesController::postMessages($_POST);
                    break;
                case 'action':
                    ActionController::postAction($_POST);
                    break;
            }
        } else {
            echo "This page isn't accessible with post.";
        }
        break;
}
