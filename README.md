# Фрагмент электроннного магазина на участке оплаты сделанного заказа

## Описание

Необходимо реализовать фрагмент электроннного магазина на участке оплаты сделанного заказа.

#### Задача

Необходимо написать код интеграции со сбербанком. Т.е. как будто бы есть большая система с электронным магазином, в ней клиенты формируют заказы, как и где  — вам не важно. Главное, что у клиента уже есть несколько заказов и клиент собирается оплатить один из них. Ваша задача написать участок с оплатой одного из заказов клиента. 

Список задач:

- создать rails 5+ приложение
- сгенерировать описанные в блоке “сущности” модели
- сделать rake-task для создания случайного заказа со случайными клиентскими данными
- сделать очень упрощенный “личный” кабинет клиента
- Контроллер и view для личного кабинета
- список заказов
- страница заказа
- оплата заказа
- Сделать сервис оплаты в сбербанк.
    - По нажатии на кнопку оплатить региструется заказ в сбербанке (Документация тут — https://securepayments.sberbank.ru/wiki/doku.php/integration:api:rest:requests:register_cart)
    - Отдельный роут, на который будут приходить колбеки от Сбера об оплате или ошибке оплаты заказов: https://securepayments.sberbank.ru/wiki/doku.php/integration:api:callback:start
- Само по себе взаимодействие со сбером протестировать не получится — нужны учетные записи, это не обязательно. Но нужно сделать тесты для сервиса оплаты и обработки колбека



## Запуск проекта


## Возможные ошибки при запуске

- #### ``` ```
Решение: `chmod +x backend/docker/entrypoints/entrypoint.sh`