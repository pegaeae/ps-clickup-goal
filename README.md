# ps-clickup-goal
Display clickup goals as wallpaper

## how to use it

1. install scripts in a secured folder _(example : "**%userprofile%\Documents\MyApps\pegaeae\ps-clickup-goals**")_
1. install dependencies ([ps-lib](https://github.com/pegaeae/ps-lib))
1. configure **clickup-token.json**
1. run once in order to have access to **{appFolder}\cache\goals.txt**
1. configure **clickup-goals.json** with as many goals you want
1. test your configuration by executing the script manually
1. schedule a task in windows scheduler in order to automate script execution. ```cscript {appFolder}\ps-clickup-goal.vbs``` 

**important** : take care to not expose token.json to other users.

## folder structure

```
appFolder
  | ps-clickup-goal.ps1
  | ps-clickup-goal.vbs
  | cache
  |   | goals.txt
  |   | png files
  |- config
  |   | clickup-token.json
  |   | clickup-goals.json
  |- ps-lib
       | .psm1 files from https://github.com/pegaeae/ps-lib
```

## clickup-token.json

```
{
	"Token":  "pk_yourClickUpTokenHere"
}
```

## clickup-goals.json

it's an array of goal config. put as many goals as you want.

```
[
    {
        "goalID"        :  "yourGoalIdHere",
        "goalName"      :  "yourGoalNameHere",
        "left"          :  20,
        "top"           :  20,
        "width"         :  500,
        "height"        :  30,
        "progressWidth" :  100
    },
        {
        "goalID"        :  "yourGoalIdHere",
        "goalName"      :  "yourGoalNameHere",
        "left"          :  20,
        "top"           :  20,
        "width"         :  500,
        "height"        :  30,
        "progressWidth" :  100
    }
]
```
