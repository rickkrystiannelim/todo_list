# todolist

TODO List

A simple TODO list app.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Architecture: MVVM
State management: 
- ChangeNotifier
- ChangeNotifierProvider
- Consumer
Database: Realm DB (manually implemented, limitation: Android only)

App design:
1. Pages
    - TODOListPage = home page
    - CreateTODOPage = add/edit todo page
2. State Models
    - TODOListModel = home page model state
                    = app level/universal state
    - CreateTODOModel = add/edit todo page model state
                      = can only be accessed by CreateTODOPage
3. Data Models
    - TODO = todo objects
           = DB object
4. Repository
    - AppRepo = DB transactions via MethodChannel (limitation: Android only)

Native implementations:
- method channel communication
- Realm DB transactions
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++