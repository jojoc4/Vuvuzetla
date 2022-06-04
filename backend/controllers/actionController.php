<?php

class ActionController
{

    /* This is the controller function that is called to add a like or dislike */
    public static function postAction($params)
    {
        $msg = Messages::getMessage($params['id']);
        if ($params['uuid'] == $msg->uuid) {
            //cannot action on own messages
            http_response_code(403);
            exit;
        }
        $a = Actions::getOwn($params['id'], $params['uuid']);
        if (!isset($a->id)) {
            $a = new Actions();
            $a->message_id = $params['id'];
            $a->uuid = $params['uuid'];
            $a->value = $params['value'];
            $a->insert();
        } else {
            $a->value = $params['value'];
            $a->update();
        }
        echo json_encode($a);
    }
}
