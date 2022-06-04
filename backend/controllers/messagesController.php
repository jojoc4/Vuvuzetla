<?php

class messagesController
{
    /* A controller function that is responsible for getting the messages from the database. */
    public static function getMessages($params)
    {
        $messages = Messages::getMessages($params['longitude'], $params['latitude'], $params['category']);
        if (empty($messages)) {
            //return nearest message coordinates
            return json_encode(["messages" => [], "nearest" => Messages::getNeraest($params['longitude'], $params['latitude'], $params['category'])]);
        } else {
            //add like status foreach messages
            foreach ($messages as $key => $message) {
                $messages[$key] = array_merge((array) $message, Actions::getStatus($message->id, $params['uuid']));
            }
            return json_encode(["messages" => $messages, "nearest" => ["direction" => 0, "distance" => 0]]);
        }
    }

    /* This function is responsible for creating a new message in the database. */
    public static function postMessages($params)
    {
        $message = new Messages();
        $message->uuid = $params['uuid'];
        $message->message = $params['message'];
        $message->username = $params['username'];
        $message->longitude = $params['longitude'];
        $message->latitude = $params['latitude'];
        $message->category = $params['category'];
        $message->insert();
        return json_encode(array_merge((array) Messages::getMessage($message->id), Actions::getStatus($message->id, $params['uuid'])));
    }

    public static function censor($params)
    {
        Messages::censor($params['id']);
    }

    public static function delete($params)
    {
        Messages::delete($params['id']);
    }

    public static function deleteUser($params)
    {
        Messages::deleteUser($params['id']);
    }
}
