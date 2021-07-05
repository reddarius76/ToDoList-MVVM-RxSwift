# ToDoList-Rx-MVVM-

В приложение ToDoList можно:
1. Создать задачу.
2. Посмотреть детали задачи.
3. Редактировать задачу.
4. Удалить задачу.

Приложение содержит три экрана:
1. Экран списка задача.
2. Экран с деталями задачи.
3. Экран создания/редактирования задачи.

- На экране списка используется UITableView с возможностью удаления задачи по swipe.
В списке отображается название задачи и срок ее выполнения.
Из этого экрана можно перейти в создание задачи. 
При нажатии на задачу, переходим на экран с деталями задачи.

- В деталях - вся информация о задаче. 
Из этого экрана можно перейти в создание или редактирование задачи.

- Экран создания и редактирования задачи содержит форму ввода и кнопку "сохранить". 
При создании задачи можно ввести название, описание, срок выполнения и приоритет. 
После успешного сохранения приложение направляет на экран списка задач.

В проекте используется: MVVM, RxSwift + RxCocoa, PinLayout.
