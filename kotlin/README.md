# Advent of Code 2023 Kotlin Solutions

File structure for this project is as follows

```
.
├── README.md                               README file
├── build.gradle.kts                        Gradle configuration created with Kotlin DSL
├── settings.gradle.kts                     Gradle project settings
├── gradle*                                 Gradle wrapper files
└── src/main            
    ├── kotlin          
    │   ├── Main.kt                         Main executable for project
    │   └── solutions                       Folder containing solutions for each day
    │       ├── Day.kt                      Interface for solving an individual day
    │       └── Day01.kt                    Solution to Day01
    │           ...         
    └── resources                           
        └── day01                           Folder for resources related to day01
            └── ExamplePart1In.txt          Input for example for part 1 of the problem of the day
            └── ExamplePart1Out.txt         Solution to example for part 1 of the problem of the day
            └── ExamplePart2In.txt          Input for example for part 2 of the problem of the day
            └── ExamplePart2Out.txt         Solution to example for part 2 of the problem of the day
            └── Part1In.txt                 Input for part 1 of the problem of the day
            └── Part2In.txt                 Input for part 2 of the problem of the day
            ...
```