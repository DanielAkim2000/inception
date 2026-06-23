#!/bin/bash
mkdir -p /run/php
exec php-fpm8.2 -F
