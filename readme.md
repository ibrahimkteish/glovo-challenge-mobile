# Navigation
This applciation uses the coordinator pattern taking into consideration the SOLID principles, where each class interacts with the others using protocols rather than interacting with concrete implementations of objects. The viewControllers in this pattern operate independently from one another. Each viewController communicates with its associated coordinator using protocols. The coordinator then is responsible of deciding which viewController to present/push next. This is done using a routing protocol implemented by a router instance which is part of the coordinator itself.

# Networking
The application uses native iOS network class (URLSession), without any use of a third party library, with custom session configuration. The API request is in itself a protocol implemented by an Enum (Moya Style) respresenting all possible requests along with their REST parameters. Each request is handled by a network operation that executes in a certain dispatcher (dev / prod). An API service bundles all the network operations to help us run with mock data or production data.

# UI
UI elements are driven by Observable streams (RxSwift / RxCocoa) using a binding mechanism that allows using those streams as a data source while benefiting from the ability to apply high order functions on them to achieve better UI performance.
