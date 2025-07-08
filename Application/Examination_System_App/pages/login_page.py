import flet as ft
from services.api_client import api_client

class LoginPage(ft.View):
    def __init__(self, page: ft.Page):
        super().__init__(route="/")
        self.page = page

        # Input fields
        self.username = ft.TextField(
            label="Username",
            width=300,
            color="white",
            border_color="white",
            label_style=ft.TextStyle(color="white"),
            hint_style=ft.TextStyle(color="white54"),
            autofocus=True
        )

        self.password = ft.TextField(
            label="Password",
            password=True,
            width=300,
            border_color="white",
            label_style=ft.TextStyle(color="white"),
            hint_style=ft.TextStyle(color="white54")
        )

        self.role_dropdown = ft.Dropdown(
            label="Select Role",
            width=300,
            color="white",
            border_color="white",
            label_style=ft.TextStyle(color="white"),
            hint_style=ft.TextStyle(color="white54"),
            options=[
                ft.dropdown.Option("Student"),
                ft.dropdown.Option("Instructor"),
                ft.dropdown.Option("Admin")
            ],
        )

        self.login_btn = ft.ElevatedButton("Login", on_click=self.login, width=300)

        # 🔴 Error text displayed under login button
        self.error_text = ft.Text(value="", color="red", size=14)

        # Layout
        main_column = ft.Column(
            [
                ft.Text("ITI Examination System", theme_style="headlineMedium", color="Red"),
                ft.Text("Login", theme_style="headlineMedium", color="White"),
                self.username,
                self.password,
                self.role_dropdown,
                self.login_btn,
                self.error_text  # 👈 error shown here
            ],
            alignment=ft.MainAxisAlignment.CENTER,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            expand=True,
        )

        centered_form = ft.Container(
            content=main_column,
            alignment=ft.alignment.center,
            expand=True
        )

        self.controls.append(
            ft.Stack([
                ft.Image(
                    src="Assets/loginPage/background.jpg",
                    fit=ft.ImageFit.COVER,
                    width=float('inf'),
                    height=float('inf')
                ),
                centered_form
            ], expand=True)
        )

    def login(self, _):
        self.error_text.value = ""  # clear old errors

        # Check if role is selected
        if not self.role_dropdown.value:
            self.show_error("Please select a role.")
            return

        # Send login request
        resp = api_client.login(
            self.username.value,
            self.password.value,
            self.role_dropdown.value
        )

        if resp and resp.ok:
            user = resp.json().get("user", {})
            role = (user.get("Role") or self.role_dropdown.value).strip().lower()

            self.page.client_storage.set("user", user)
            if api_client.token:
                self.page.client_storage.set("token", api_client.token)

            if role == "student":
                self.page.go("/student")
            elif role == "instructor":
                self.page.go("/instructor")
            elif role == "admin":
                self.page.go("/admin")
            else:
                self.show_error("Unknown role returned by server.")
        else:
            try:
                error_msg = resp.json().get("message", "Login failed. Check credentials.")
            except Exception:
                error_msg = "Something went wrong."
            self.show_error(error_msg)

    def show_error(self, msg):
        self.error_text.value = msg
        self.page.update()
