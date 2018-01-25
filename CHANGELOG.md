0.6.6

- fix `UINavigationControllerDelegate` behavior, always pass user **VC**

0.6.5

- use `navigationItem.title` first, then `title`

0.6.4

- fix #147, `prefersHomeIndicatorAutoHidden` support

0.6.3

- fix #92, now you can use `self.navigationController.viewControllers` to access siblings

0.6.2

- fix #96

0.6.1

- fix `-preferredStatusBarStyle`

0.6.0

- *Notice*: default behavior change. If **VC** has set left item in `-viewDidLoad`, then interactive pop will be disabled by default, you can still set `rt_disableInteractivePop` to **NO** if you really want it.

0.5.26

- interactive push support

```ruby
pod 'RTRootNavigationController', :subspecs = ['Push']
```

0.5.25

- deprecate `customBackItemWithTarget:action:`, use `rt_customBackItemWithTarget:action:` instead

0.5.24

- add `popViewControllerAnimated:complete:` method

0.5.23

- add a **NOTICE** for the view controller hierarchy change
- fix #39

0.5.22

- fix delegate method calling

0.5.21

- fix #27

0.5.20

- fix #16

0.5.19

- fix #14

0.5.18

- fix #12

0.5.17

- fix #11

0.5.16

- potential bug

0.5.15

- fix #7

0.5.14

- fix #4

0.5.13

- add `removeViewController:animated:` method
- fix pop to root completion block calling
