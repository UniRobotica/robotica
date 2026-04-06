document.addEventListener("DOMContentLoaded", function () {
  const logo = document.querySelector(".navbar-brand img, .logo img, img.logo");
  if (logo) {
    const parent = logo.parentElement;
    if (parent && parent.tagName !== "A") {
      const link = document.createElement("a");
      link.href = "https://unirobotica.com.br";
      link.target = "_blank";
      link.rel = "noopener noreferrer";
      parent.insertBefore(link, logo);
      link.appendChild(logo);
    } else if (parent && parent.tagName === "A") {
      parent.href = "https://unirobotica.com.br";
      parent.target = "_blank";
      parent.rel = "noopener noreferrer";
    }
  }
});