open Prisma

type user = {
  "id": Uuid.t,
  "name": string,
  "email": string,
  "password": string,
  "isAdmin": bool,
  "createdAt": string,
  "updatedAt": string,
}

@get external user: t => model<'t> = "user"

type sysConfig = {"id": Uuid.t, "allowRegistration": bool}

@get external sysConfig: t => model<'t> = "sysConfig"

type config = {
  "id": Uuid.t,
  "pomodoroDuration": int,
  "shortBreakDuration": int,
  "longBreakDuration": int,
  "longBreakInterval": int,
  "autoStartBreak": bool,
  "autoStartPomodoro": bool,
  "showCompletedTasks": bool,
  "createdAt": string,
  "updatedAt": string,
}

@get external config: t => model<'t> = "config"

type project = {
  "id": Uuid.t,
  "title": string,
  "description": string,
  "createdAt": string,
  "updatedAt": string,
}

@get external project: t => model<'t> = "project"

type task = {
  "id": Uuid.t,
  "title": string,
  "description": string,
  "completed": bool,
  "plannedPomo": int,
  "finishedPomo": int,
  "dueDate": string,
  "includeBeforeDueDate": bool,
  "createdAt": string,
  "updatedAt": string,
}

@get external task: t => model<'t> = "task"
