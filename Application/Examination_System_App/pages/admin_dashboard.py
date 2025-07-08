import flet as ft
from services.api_client import api_client


class AdminDashboard(ft.View):
    def __init__(self, page: ft.Page):
        super().__init__(route="/admin")
        self.page = page
        self.users = []
        self.courses = []
        self.user_id_counter = 1

        self.add_user_visible = False
        self.add_course_visible = False

        # ---------------- User Fields ----------------
        self.username = ft.TextField(label="Username", color="black", width=300)
        self.first_name = ft.TextField(label="First Name", color="black", width=300)
        self.last_name = ft.TextField(label="Last Name", color="black", width=300)
        self.email = ft.TextField(label="Email", color="black", width=300)
        self.password = ft.TextField(label="Password", password=True, can_reveal_password=True, color="black", width=300)
        self.role = ft.Dropdown(
            label="Role", color="black", width=300,
            options=[ft.dropdown.Option("Student"), ft.dropdown.Option("Instructor"), ft.dropdown.Option("Admin")]
        )
        self.dob = ft.TextField(label="Date of Birth (YYYY-MM-DD)", color="black", width=300)
        self.gender = ft.Dropdown(
            label="Gender", color="black", width=300,
            options=[ft.dropdown.Option("M"), ft.dropdown.Option("F")]
        )
        self.address = ft.TextField(label="Address", color="black", width=300)
        self.salary = ft.TextField(label="Salary", color="black", width=300)
        self.branch_id = ft.TextField(label="Branch ID", color="black", width=300)
        self.major = ft.TextField(label="Major", color="black", width=300)
        self.gpa = ft.TextField(label="GPA", color="black", width=300)
        self.intake = ft.TextField(label="Intake ID", color="black", width=300)
        self.track_id = ft.TextField(label="Track ID", color="black", width=300)
        self.error_message = ft.Text("", color="red")

        self.add_user_form = ft.Column([
            self.username, self.first_name, self.last_name, self.email, self.password,
            self.role, self.dob, self.gender, self.address, self.salary,
            self.branch_id, self.major, self.gpa, self.intake, self.track_id,
            ft.ElevatedButton("Submit User", icon=ft.Icons.CHECK, on_click=self.submit_user),
            self.error_message
        ], visible=False)

        self.user_list_column = ft.Column()

        # ---------------- Course Fields ----------------
        self.code_input = ft.TextField(label="Course Code", width=200, color="black")
        self.name_input = ft.TextField(label="Course Name", width=300, color="black")

        self.add_course_form = ft.Column([
            ft.Row([self.code_input, self.name_input]),
            ft.ElevatedButton("Submit Course", icon=ft.Icons.CHECK, on_click=self.submit_course)
        ], visible=False)

        self.course_list_column = ft.Column()

        # ---------------- Page Layout ----------------
        self.controls = [
            ft.Column(
                controls=[
                    ft.Container(
                        ft.Row([
                            ft.Text("🎓 Admin Dashboard", theme_style="headlineMedium", expand=True, color="white"),
                            ft.ElevatedButton("Logout", icon=ft.Icons.LOGOUT, on_click=self.logout, bgcolor="white", color="black")
                        ]),
                        bgcolor="red", padding=20
                    ),
                    ft.Container(
                        content=ft.Column([
                            ft.Text("👥 Users", theme_style="headlineSmall", color="White"),
                            ft.ElevatedButton("➕ Add User", icon=ft.Icons.PERSON_ADD, on_click=self.toggle_add_user),
                            self.add_user_form,
                            self.user_list_column
                        ]),
                        padding=20
                    ),
                    ft.Container(
                        content=ft.Column([
                            ft.Text("📘 Courses", theme_style="headlineSmall", color="White"),
                            ft.ElevatedButton("➕ Add Course", icon=ft.Icons.LIBRARY_ADD, on_click=self.toggle_add_course),
                            self.add_course_form,
                            self.course_list_column
                        ]),
                        padding=20
                    )
                ],
                scroll="auto",
                expand=True
            )
        ]

    def did_mount(self):
        self.load_users()
        self.load_courses()

    def toggle_add_user(self, _):
        self.add_user_visible = not self.add_user_visible
        self.add_user_form.visible = self.add_user_visible
        self.add_user_form.update()

    def toggle_add_course(self, _):
        self.add_course_visible = not self.add_course_visible
        self.add_course_form.visible = self.add_course_visible
        self.add_course_form.update()

    def submit_user(self, _):
        try:
            payload = {
                "Username": self.username.value.strip(),
                "FirstName": self.first_name.value.strip(),
                "LastName": self.last_name.value.strip(),
                "Email": self.email.value.strip(),
                "PasswordHash": self.password.value.strip(),
                "Role": self.role.value,
                "DateOfBirth": self.dob.value.strip(),
                "Gender": self.gender.value,
                "Address": self.address.value.strip(),
                "Salary": float(self.salary.value.strip()),
                "BranchID": int(self.branch_id.value.strip()),
                "Major": self.major.value.strip(),
                "GPA": float(self.gpa.value.strip()),
                "IntakeID": self.intake.value.strip(),
                "TrackID": int(self.track_id.value.strip())
            }

            response = api_client.post("/admin/create_user", json=payload)
            if response and response.ok:
                self.users.append({
                    "id": self.user_id_counter,
                    "name": f"{payload['FirstName']} {payload['LastName']}",
                    "email": payload['Email'],
                    "role": payload['Role']
                })
                self.user_id_counter += 1
                self.load_users()
                self.toggle_add_user(None)
                self.page.snack_bar = ft.SnackBar(ft.Text("✅ User added"))
            else:
                msg = response.json().get("message", "❌ Failed to add user")
                self.error_message.value = msg
                self.page.snack_bar = ft.SnackBar(ft.Text(msg))
        except Exception as e:
            self.error_message.value = f"❌ Error: {str(e)}"
        self.page.snack_bar.open = True
        self.page.update()

    def load_users(self):
        self.user_list_column.controls.clear()
        for user in self.users:
            self.user_list_column.controls.append(
                ft.Row([
                    ft.Text(f"👤 {user['id']}: {user['name']} - {user['role']}", color="black"),
                    ft.IconButton(icon=ft.Icons.DELETE, on_click=lambda e, uid=user["id"]: self.delete_user(uid))
                ])
            )
        self.user_list_column.update()

    def delete_user(self, user_id):
        self.users = [u for u in self.users if u["id"] != user_id]
        self.load_users()

    def submit_course(self, _):
        code = self.code_input.value.strip()
        name = self.name_input.value.strip()
        if not code or not name:
            self.page.snack_bar = ft.SnackBar(ft.Text("⚠️ Course code and name required"))
            self.page.snack_bar.open = True
            self.page.update()
            return
        self.courses.append({"code": code, "name": name})
        self.code_input.value = ""
        self.name_input.value = ""
        self.load_courses()
        self.toggle_add_course(None)
        self.page.snack_bar = ft.SnackBar(ft.Text("✅ Course added"))
        self.page.snack_bar.open = True
        self.page.update()

    def load_courses(self):
        self.course_list_column.controls.clear()
        for course in self.courses:
            self.course_list_column.controls.append(
                ft.Row([
                    ft.Text(f"📘 {course['code']}: {course['name']}", color="black"),
                    ft.IconButton(icon=ft.Icons.DELETE, on_click=lambda e, code=course["code"]: self.delete_course(code))
                ])
            )
        self.course_list_column.update()

    def delete_course(self, code):
        self.courses = [c for c in self.courses if c["code"] != code]
        self.load_courses()

    def logout(self, _):
        self.page.client_storage.clear()
        self.page.go("/")
