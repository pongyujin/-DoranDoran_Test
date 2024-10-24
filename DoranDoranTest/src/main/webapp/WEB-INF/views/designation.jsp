<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Modal Example</title>
<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Outfit:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
<!-- Styles -->
<style>
/* Basic CSS overrides */
body {
	line-height: 1.5;
	min-height: 100vh;
	font-family: "Outfit", sans-serif;
	color: #2d232e;
	background-color: #c8c0bd;
	position: relative;
}

button, input, select, textarea {
	font: inherit;
}

a {
	color: inherit;
}

/* Scrollbar styling */
* {
	scrollbar-width: 0;
}

*::-webkit-scrollbar {
	background-color: transparent;
	width: 12px;
}

*::-webkit-scrollbar-thumb {
	border-radius: 99px;
	background-color: #ddd;
	border: 4px solid #fff;
}

/* Modal styling */
.modal {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	display: flex;
	align-items: center;
	justify-content: center;
	background-color: rgba(0, 0, 0, 0.25);
}

.modal-container {
	max-height: 90vh;
	max-width: 500px;
	margin-left: auto;
	margin-right: auto;
	background-color: #fff;
	border-radius: 16px;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	box-shadow: 0 15px 30px 0 rgba(0, 0, 0, 0.25);
}

.modal-container-header {
	padding: 16px 32px;
	border-bottom: 1px solid #ddd;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.modal-container-title {
	display: flex;
	align-items: center;
	gap: 8px;
	line-height: 1;
	font-weight: 700;
	font-size: 1.125rem;
}

.modal-container-title svg {
	width: 32px;
	height: 32px;
	color: #750550;
}

.modal-container-body {
	padding: 24px 32px 51px;
	overflow-y: auto;
}

.rtf h1, .rtf h2, .rtf h3, .rtf h4, .rtf h5, .rtf h6 {
	font-weight: 700;
}

.rtf h1 {
	font-size: 1.5rem;
	line-height: 1.125;
}

.rtf h2 {
	font-size: 1.25rem;
	line-height: 1.25;
}

.rtf h3 {
	font-size: 1rem;
	line-height: 1.5;
}

.rtf>*+* {
	margin-top: 1em;
}

.rtf>*+:is(h1, h2, h3) {
	margin-top: 2em;
}

.rtf>:is(h1, h2, h3)+* {
	margin-top: 0.75em;
}

.rtf ul, .rtf ol {
	margin-left: 20px;
	list-style-position: inside;
}

.rtf ol {
	list-style: numeric;
}

.rtf ul {
	list-style: disc;
}

.modal-container-footer {
	padding: 20px 32px;
	display: flex;
	align-items: center;
	justify-content: flex-end;
	border-top: 1px solid #ddd;
	gap: 12px;
	position: relative;
}

.modal-container-footer:after {
	content: "";
	display: block;
	position: absolute;
	top: -51px;
	left: 24px;
	right: 24px;
	height: 50px;
	flex-shrink: 0;
	background-image: linear-gradient(to top, rgba(255, 255, 255, 0.75),
		transparent);
	pointer-events: none;
}

.button {
	padding: 12px 20px;
	border-radius: 8px;
	background-color: transparent;
	border: 0;
	font-weight: 600;
	cursor: pointer;
	transition: 0.15s ease;
}

.button.is-ghost:hover, .button.is-ghost:focus {
	background-color: #dfdad7;
}

.button.is-primary {
	background-color: #750550;
	color: #fff;
}

.button.is-primary:hover, .button.is-primary:focus {
	background-color: #4a0433;
}

.icon-button {
	padding: 0;
	border: 0;
	background-color: transparent;
	width: 40px;
	height: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
	line-height: 1;
	cursor: pointer;
	border-radius: 8px;
	transition: 0.15s ease;
}

.icon-button svg {
	width: 24px;
	height: 24px;
}

.icon-button:hover, .icon-button:focus {
	background-color: #dfdad7;
}
</style>
</head>
<body>

	<!-- Modal HTML Structure -->
	<div v-if="isModalVisible" id="startSailModal" class="modal" @click="outsideClick">
		<article class="modal-container">
			<header class="modal-container-header">
				<h1 class="modal-container-title">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
						width="24" height="24" aria-hidden="true">
          <path fill="none" d="M0 0h24v24H0z" />
          <path fill="currentColor"
							d="M14 9V4H5v16h6.056c.328.417.724.785 1.18 1.085l1.39.915H3.993A.993.993 0 0 1 3 21.008V2.992C3 2.455 3.449 2 4.002 2h10.995L21 8v1h-7zm-2 2h9v5.949c0 .99-.501 1.916-1.336 2.465L16.5 21.498l-3.164-2.084A2.953 2.953 0 0 1 12 16.95V11zm2 5.949c0 .316.162.614.436.795l2.064 1.36 2.064-1.36a.954.954 0 0 0 .436-.795V13h-5v3.949z" />
        </svg>
					Terms and Services
				</h1>
				<button class="icon-button">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
						width="24" height="24">
          <path fill="none" d="M0 0h24v24H0z" />
          <path fill="currentColor"
							d="M12 10.586l4.95-4.95 1.414 1.414-4.95 4.95 4.95 4.95-1.414 1.414-4.95-4.95-4.95 4.95-1.414-1.414 4.95-4.95-4.95-4.95L7.05 5.636z" />
        </svg>
				</button>
			</header>
			<section class="modal-container-body rtf">
				<h2>항해 설정</h2>

				<p>출발지 목적지 경유지 설정</p>

				<h2>자율운항 이용약관</h2>
				<ol>
					<li>자율운항선박 운항해역의 지정·변경·해제(안 제2조) 해수부장관은 자율운항선박 운항해역 지정·변경·해제 절차 등 규정</li>
					<li>자율운항선박 및 기자재 안전성 평가(안 제3조) 안전성 평가의 신청, 심사·평가 및 활용에 관한 사항 규정</li>
					<li>운항의 승인신청(안 제4조) 자율운항선박의 운항 승인 신청 절차 규정</li>
					<li>운항의 승인(안 제5조) 자율운항선박의 운항 승인·불승인 관련 사항 규정</li>
					<li>규제 신속확인(안 제6조) 규제 신속확인 신청서 및 통지서 서식</li>
				</ol>

				<p>Utilitatis causa amicitia est quaesita. Qui autem de summo
					bono dissentit de tota philosophiae ratione dissentit. Quamquam non
					negatis nos intellegere quid sit voluptas, sed quid ille dicat. Sed
					emolumen</p>
					
			</section>
			<footer class="modal-container-footer">
				<button class="button is-ghost">Decline</button>
				<button class="button is-primary">Accept</button>
			</footer>
		</article>
	</div>

</body>
</html>
