<?php

namespace MyNamespace;

class MyClass
{
    public $name;
    public $age;

public function __construct($name, $age)
{
    $this->name = $name;
    $this->age = $age;
}

public function displayInfo()
{
    echo "Name: $this->name, Age: $this->age";
}

    // Missing visibility keyword (PSR-12 violation)
    // function invalidMethod($param)
    // {
    //     // Code here
    // }

    // // Trailing whitespace at the end of the line (common error)
    // public function anotherInvalidMethod()
    // {
    //     // Do something
    // }
}
