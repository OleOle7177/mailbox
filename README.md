# Mailbox

Приложение позволяет просматривать почту gmail-аккаунта пользователя (используется протокол POP3).

## Установка

Установите гемы:

	$ bundle install

Создайте базу данных и запустите миграции: 

	$ rake db:create
	$ rake db:schema:load 

Запустите приложение: 

	$ rails s

## Работа с приложением: 

Для того, чтобы иметь возможность просматривать почту gmail-аккаунта, при регистрации необходимо указывать связку почта-пароль такую же, как и в действительном почтовом ящике. 

Кроме того, в аккаунте пользователя на gmail необходимо разрешить доступ к почте сторонним приложениям. 

## Особенности реализации:

При получении почты с сервера и сохранении сообщений в локальную базу данных все ошибки логгируются в файл mail.log. 

Все прикрепленные к сообщениям файлы хранятся в папке storage (в корне приложения).

## Тестирование: 

Для запуска всех тестов наберите в командной строке: 

	$ rspec
___________________________________________________________

Mailbox is an application that provides user an ability to get emails from his gmail-account (POP3 protocol is used). 

## Installation

Install gems with bundler:

	$ bundle install

Create database and run migrations: 

	$ rake db:create
	$ rake db:schema:load 

Launch the application: 

	$ rails s

## Start: 

You should register with real email address and password exactly the same as on gmail account you want to work with. 

You should also give an access to unsafe applications in your gmail account.

## Features:

All errors during retrieving emails and saving them to database are logged in mail.log file.

All attachments are saved to storage folder in root folder of your application.  

## Tests: 

Run tests with command:

	$ rspec
