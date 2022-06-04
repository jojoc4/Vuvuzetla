<?php

class Actions
{

    public $id, $message_id, $uuid, $value;

    /* This is a function that returns the status of a message. */
    public static function getStatus($messageId, $uuid)
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT * FROM actions WHERE message_id = :messageId");
        $stmt->execute(['messageId' => $messageId]);
        $actions = $stmt->fetchall(PDO::FETCH_CLASS, "Actions");
        $count = 0;
        $status = 0;
        foreach ($actions as $action) {
            $count += $action->value;
            if ($action->uuid == $uuid) {
                $status = $action->value;
            }
        }
        return ["status" => $status, "count" => $count];
    }

    /* This is a function that returns the action of a message for a user. */
    public static function getOwn($messageId, $uuid)
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT * FROM actions WHERE message_id = :messageId AND uuid = :uuid");
        $stmt->execute(['messageId' => $messageId, "uuid" => $uuid]);
        $stmt->setFetchMode(PDO::FETCH_CLASS, 'Actions');
        return $stmt->fetch();
    }


    /* This is a function that inserts a new action into the database. */
    public function insert()
    {
        global $pdo;
        $stmt = $pdo->prepare("INSERT INTO actions (uuid, message_id, value) VALUES(:uuid, :message_id, :value)");
        $stmt->execute([
            ':uuid' => $this->uuid,
            ':message_id' => $this->message_id,
            ':value' => $this->value,
        ]);
        $this->id = $pdo->lastInsertId();
    }

    /* This is a function that updates the value of an action. */
    public function update()
    {
        global $pdo;
        $stmt = $pdo->prepare("UPDATE `actions` SET `value` = :value WHERE `id` = :id");
        $stmt->execute([
            ':value' => $this->value,
            ':id' => $this->id,
        ]);
    }
}
