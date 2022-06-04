<?php

class Messages
{

    public $id, $longitude, $latitude, $message, $uuid, $username, $category;

    /* It's a function that returns a message by id. */
    public static function getMessage($id)
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT * FROM messages WHERE id = :id");
        $stmt->execute(['id' => $id]);
        $stmt->setFetchMode(PDO::FETCH_CLASS, 'Messages');
        return $stmt->fetch();
    }


    /* It's a function that returns a message by id. */
    public static function getAllMessages()
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT * FROM messages");
        $stmt->execute();
        return $stmt->fetchall(PDO::FETCH_CLASS, "Messages");
    }

    /* It's a function that returns a list of messages. */
    public static function getMessages($longitude, $latitude, $cat)
    {
        global $pdo;
        $r = [];
        //TODO - optimize by filtering min and max long and lat
        if ($cat == 'All') {
            $stmt = $pdo->prepare("SELECT * FROM messages");
            $stmt->execute();
        } else {
            $stmt = $pdo->prepare("SELECT * FROM messages WHERE category = :cat");
            $stmt->execute(['cat' => $cat]);
        }
        $messages = $stmt->fetchall(PDO::FETCH_CLASS, "Messages");
        foreach ($messages as $msg) {
            if ($msg->distanceToPoint($longitude, $latitude) <= 2) {
                $r[] = $msg;
            }
        }
        return $r;
    }

    /* It's a function that returns distance and direction to nearest messages. */
    public static function getNeraest($longitude, $latitude, $cat)
    {
        global $pdo;
        $r = [];
        if ($cat == 'All') {
            $stmt = $pdo->prepare("SELECT * FROM messages");
            $stmt->execute();
        } else {
            $stmt = $pdo->prepare("SELECT * FROM messages WHERE category = :cat");
            $stmt->execute(['cat' => $cat]);
        }
        $messages = $stmt->fetchall(PDO::FETCH_CLASS, "Messages");
        $nearest = null;
        $nearestDistance = 1000000000;
        foreach ($messages as $msg) {
            if ($msg->distanceToPoint($longitude, $latitude) < $nearestDistance) {
                $nearest = $msg;
                $nearestDistance = $msg->distanceToPoint($longitude, $latitude);
            }
        }

        $long1 = deg2rad($longitude);
        $long2 = deg2rad($nearest->longitude);
        $lat1 = deg2rad($latitude);
        $lat2 = deg2rad($nearest->latitude);
        $dlong = $long2 - $long1;
        $dlati = $lat2 - $lat1;
        $dir = rad2deg(atan($dlati / $dlong));

        //dir corerection
        if ($dir < 0) $dir *= -1;

        if ($longitude < $nearest->longitude) {
            //cadran 1 ou 2
            if ($latitude < $nearest->latitude) {
                //1
            } else {
                //2
                $dir += 90;
            }
        } else {
            //cadran 3 ou 4
            if ($latitude > $nearest->latitude) {
                //3
                $dir += 180;
            } else {
                //4
                $dir += 270;
            }
        }

        return ["direction" => $dir, "distance" => $nearestDistance];
    }

    /* Insert Message to db. */
    public function insert()
    {
        global $pdo;
        $stmt = $pdo->prepare("INSERT INTO messages(uuid, username, message, longitude, latitude, category) VALUES(:uuid, :username, :message, :longitude, :latitude, :category)");
        $stmt->execute([
            ':uuid' => $this->uuid,
            ':username' => $this->username,
            ':message' => $this->message,
            ':longitude' => $this->longitude,
            ':latitude' => $this->latitude,
            ':category' => $this->category
        ]);
        $this->id = $pdo->lastInsertId();
    }

    public static function censor($id)
    {
        global $pdo;
        $stmt = $pdo->prepare("UPDATE `messages` SET `message` = 'CENSORED BY MODERATION' WHERE `messages`.`id` = " . $id);
        $stmt->execute();
    }

    public static function delete($id)
    {
        global $pdo;
        $stmt = $pdo->prepare("DELETE FROM `messages` WHERE `messages`.`id` = " . $id);
        $stmt->execute();
    }

    public static function deleteUser($id)
    {
        global $pdo;
        $stmt = $pdo->prepare("DELETE FROM `messages` WHERE `messages`.`uuid` = \"" . $id . "\"");
        $stmt->execute();
    }

    /* This function is calculating the distance between a message and a point on the earth. */
    private function distanceToPoint($longitude, $latitude)
    {
        $long1 = deg2rad($longitude);
        $long2 = deg2rad($this->longitude);
        $lat1 = deg2rad($latitude);
        $lat2 = deg2rad($this->latitude);

        //Haversine Formula
        $dlong = $long2 - $long1;
        $dlati = $lat2 - $lat1;

        $val = pow(sin($dlati / 2), 2) + cos($lat1) * cos($lat2) * pow(sin($dlong / 2), 2);

        $res = 2 * asin(sqrt($val));

        $radius = 6371;

        return ($res * $radius);
    }
}
