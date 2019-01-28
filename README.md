﻿# ReleasePrepare

<!-- TOC insertAnchor:true -->

* [ReleasePrepare]
  * [Терминология](#терминология)
  * [Назначение программы](#назначение-программы)
  * [Описание использования](#описание-использования)
  * [Файл настроек запуска работы с проектом](#настройки-запуска)
  * [Файл настроек правил рефакторинга](#настройки-правил)

<!-- /TOC -->

## Терминология:

* мастер-обработка - обработка, которая передается заказчику (релиз)
* девелоп-обработка - обработка, в которой ведется разработка

## Назначение программы и основные функции

Программа предназначена для автоматизации подготовки мастер-обработки на базе указанной девелоп-обработки:

* выгружает указанную девелоп-обработку в файлы
* рефакторит коды модулей согласно указанным правилам
* получает номер версии обработки
* формирует наименование файла мастер-обработки с учетом наименования проекта и номера релиза
* загружает обработанные исходники в мастер-обработку

Так как выгрузка и загрузка производится средствами платформы 1С, имеем ввиду - версия этой платформы 8.3.*
Должны поддерживаться при запуске конфигуратора из командной строки ключи: /DumpExternalDataProcessorOrReportToFiles и /LoadExternalDataProcessorOrReportFromFiles

## Описание использования

Для работы программы необходимо наличие двух конфигурационных файлов (в каталоге лежат два образца)

* файл с настройками запуска и параметрами рабочего проекта (Config.json)
* файл с описанием правил рефакторинга кода (RefactoringRules.json)

Файлы могут находиться как в каталоге запуска, так и в любом другом удобном для вас месте

Программа запускается на выполнение командой:

```cmd
oscript ReleasePrepare.os -prj <АлиасПроекта> -cfg <ФайлНастроек>
```

Где:
 АлиасПроекта - псевдоним проекта (ключ в файле настроек)
                Параметр -prj является обязательным
 ФайлНастроек - файл в формате JSON с описанием параметров настроек обработки различных проектов (обработок)
                Если параметр -cfg опционален. Если его пропустить, будет искаться файл config.json в каатлоге модуля

## Форматы конфигурационных файлов

### Настройки запуска

Пример - файл Config.json в каталоге проекта

```json
{
"Programs": {
   "v83": "ПутьКПлатформе\\1cv8.exe"
   },
"КаталогРелизов": "ПутьКПапкеСРелизами",
"АлиасПроекта": {
   "ФайлОбработки": "Путь\\Обработка.epf",
   "КаталогБазы1С": "ПутьКаталогаБазы1С",
   "Пользователь1С": {
      "Имя": "ИмяПользователя",
      "Пароль": "ПарольПользователя"
      },
   "ФайлПравил": "Путь\\ФайлСПравилами.json"
   }
}
```

В данном файле указаны общие для всех проектов:

* **Programs:v83** - путь к исполняемому файлу платформы ("83" - что бы не забыть о требуемой версии платформы)
* **КаталогРелизов**- путь к каталогу с релизами (сюда будут складывать артефакты сборки)

И в секции **АлиасПроекта** (это то значение, что передается в строке запуска с ключом -prj) параметры специфичные для данного проекта:

* **ФайлОбработки** - путь к файлу исходной обработки.
* **Пользователь1С**- секция с параметрами запуска платформы 1С в режиме конфигуратора
* **ФайлПравил**- путь к файлу с правилами рефакторинга (может быть своим для каждого проекта)

### Настройки правил

В процессе рефакторинга исходных кодов задаче понадобится файл с настройками правил.
Формат описание правила:

```json
"НаименованиеПравила": {
   "ИспользоватьПравило": 1,
   "Описание": "Расшифровка действия правила",
   "Шаблон": "паттерн искомой строки",
   "ЗаменитьНа": "паттерн на замену найденного"
}
```

Например файл с правилами удаления из кода строк с определением границ областей и концевых пробелов:

```json
{
   "Области": {
      "ИспользоватьПравило": 1,
      "Описание": "Удаление границ области",
      "Шаблон": "(^ *#Область .*\n+)|(^ *#КонецОбласти .*$\n*)",
      "ЗаменитьНа": ""
   },
   "КонцевыеПробелы": {
      "Описание": "Удаление концевых пробелов",
      "Шаблон": "[ \t]*$",
      "ЗаменитьНа": ""
   },
}
```

Отсутсвие в секции описания правила ключа "ИспользоватьПравило" равносильно его наличию со значением равным 1, то есть в вышеприведенном случае отработают оба правила. Для того, что бы отключить отработку правила, требуется явное присутствие ключа "ИспользоватьПравило" со значением равным 0.

## Зависимости

* OneScript https://github.com/EvilBeaver/OneScript
* json https://github.com/oscript-library/json
* cmdline https://github.com/oscript-library/cmdline
* 1commands https://github.com/oscript-library/1commands
* tempfiles https://github.com/oscript-library/tempfiles
* logos https://github.com/oscript-library/logos
