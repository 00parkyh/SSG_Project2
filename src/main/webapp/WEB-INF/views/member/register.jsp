<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %> <%-- 💡 이 한 줄만 남겨둡니다. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html
        lang="en"
        class="light-style customizer-hide"
        dir="ltr"
        data-theme="theme-default"
        data-assets-path="${pageContext.request.contextPath}/resources/assets/"
        data-template="vertical-menu-template-free"
>
<head>
    <meta charset="utf-8"/>
    <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"
    />

    <title>Register | RACL WMS</title>

    <meta name="description" content=""/>

    <link rel="icon" type="image/x-icon"
          href="${pageContext.request.contextPath}/resources/assets/img/favicon/favicon.ico"/>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link
            href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
            rel="stylesheet"
    />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/fonts/boxicons.css"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/core.css"
          class="template-customizer-core-css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/theme-default.css"
          class="template-customizer-theme-css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/demo.css"/>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/pages/page-auth.css"/>
    <script src="${pageContext.request.contextPath}/resources/assets/vendor/js/helpers.js"></script>

    <script src="${pageContext.request.contextPath}/resources/assets/js/config.js"></script>

    <style>
        .error-message {
            color: #ff3e1d;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: block;
            min-height: 1.2rem;
        }

        .success-message {
            color: #71dd37;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: block;
            min-height: 1.2rem;
        }

        .form-control.is-invalid {
            border-color: #ff3e1d;
        }

        .form-control.is-valid {
            border-color: #71dd37;
        }

        /* 제출 버튼 비활성화 상태 스타일 */
        #submitBtn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* 비밀번호 토글 버튼 */
        .cursor-pointer {
            cursor: pointer;
        }

        .input-group-text {
            background-color: transparent;
        }
    </style>
</head>

<body>
<div class="container-xxl">
    <div class="authentication-wrapper authentication-basic container-p-y">
        <div class="authentication-inner">
            <div class="card">
                <div class="card-body">
                    <div class="app-brand justify-content-center">
                        <a href="index.html" class="app-brand-link gap-2">
                  <span class="app-brand-logo demo">
                    <svg
                            width="25"
                            viewBox="0 0 25 42"
                            version="1.1"
                            xmlns="http://www.w3.org/2000/svg"
                            xmlns:xlink="http://www.w3.org/1999/xlink"
                    >
                      <defs>
                        <path
                                d="M13.7918663,0.358365126 L3.39788168,7.44174259 C0.566865006,9.69408886 -0.379795268,12.4788597 0.557900856,15.7960551 C0.68998853,16.2305145 1.09562888,17.7872135 3.12357076,19.2293357 C3.8146334,19.7207684 5.32369333,20.3834223 7.65075054,21.2172976 L7.59773219,21.2525164 L2.63468769,24.5493413 C0.445452254,26.3002124 0.0884951797,28.5083815 1.56381646,31.1738486 C2.83770406,32.8170431 5.20850219,33.2640127 7.09180128,32.5391577 C8.347334,32.0559211 11.4559176,30.0011079 16.4175519,26.3747182 C18.0338572,24.4997857 18.6973423,22.4544883 18.4080071,20.2388261 C17.963753,17.5346866 16.1776345,15.5799961 13.0496516,14.3747546 L10.9194936,13.4715819 L18.6192054,7.984237 L13.7918663,0.358365126 Z"
                                id="path-1"
                        ></path>
                        <path
                                d="M5.47320593,6.00457225 C4.05321814,8.216144 4.36334763,10.0722806 6.40359441,11.5729822 C8.61520715,12.571656 10.0999176,13.2171421 10.8577257,13.5094407 L15.5088241,14.433041 L18.6192054,7.984237 C15.5364148,3.11535317 13.9273018,0.573395879 13.7918663,0.358365126 C13.5790555,0.511491653 10.8061687,2.3935607 5.47320593,6.00457225 Z"
                                id="path-3"
                        ></path>
                        <path
                                d="M7.50063644,21.2294429 L12.3234468,23.3159332 C14.1688022,24.7579751 14.397098,26.4880487 13.008334,28.506154 C11.6195701,30.5242593 10.3099883,31.790241 9.07958868,32.3040991 C5.78142938,33.4346997 4.13234973,34 4.13234973,34 C4.13234973,34 2.75489982,33.0538207 2.37032616e-14,31.1614621 C-0.55822714,27.8186216 -0.55822714,26.0572515 -4.05231404e-15,25.8773518 C0.83734071,25.6075023 2.77988457,22.8248993 3.3049379,22.52991 C3.65497346,22.3332504 5.05353963,21.8997614 7.50063644,21.2294429 Z"
                                id="path-4"
                        ></path>
                        <path
                                d="M20.6,7.13333333 L25.6,13.8 C26.2627417,14.6836556 26.0836556,15.9372583 25.2,16.6 C24.8538077,16.8596443 24.4327404,17 24,17 L14,17 C12.8954305,17 12,16.1045695 12,15 C12,14.5672596 12.1403557,14.1461923 12.4,13.8 L17.4,7.13333333 C18.0627417,6.24967773 19.3163444,6.07059163 20.2,6.73333333 C20.3516113,6.84704183 20.4862915,6.981722 20.6,7.13333333 Z"
                                id="path-5"
                        ></path>
                      </defs>
                      <g id="g-app-brand" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                        <g id="Brand-Logo" transform="translate(-27.000000, -15.000000)">
                          <g id="Icon" transform="translate(27.000000, 15.000000)">
                            <g id="Mask" transform="translate(0.000000, 8.000000)">
                              <mask id="mask-2" fill="white">
                                <use xlink:href="#path-1"></use>
                              </mask>
                              <use fill="#696cff" xlink:href="#path-1"></use>
                              <g id="Path-3" mask="url(#mask-2)">
                                <use fill="#696cff" xlink:href="#path-3"></use>
                                <use fill-opacity="0.2" fill="#FFFFFF" xlink:href="#path-3"></use>
                              </g>
                              <g id="Path-4" mask="url(#mask-2)">
                                <use fill="#696cff" xlink:href="#path-4"></use>
                                <use fill-opacity="0.2" fill="#FFFFFF" xlink:href="#path-4"></use>
                              </g>
                            </g>
                            <g
                                    id="Triangle"
                                    transform="translate(19.000000, 11.000000) rotate(-300.000000) translate(-19.000000, -11.000000) "
                            >
                              <use fill="#696cff" xlink:href="#path-5"></use>
                              <use fill-opacity="0.2" fill="#FFFFFF" xlink:href="#path-5"></use>
                            </g>
                          </g>
                        </g>
                      </g>
                    </svg>
                  </span>
                            <span class="app-brand-text demo text-body fw-bolder">RACL</span>
                        </a>
                    </div>
                    <h4 class="mb-2">회원가입 🚀</h4>
                    <p class="mb-4">RACL WMS와 함께 비즈니스를 시작하세요.</p>

                    <form id="formRegistration" class="mb-3" method="POST" action="/member/register">
                        <!-- 아이디 -->
                        <div class="mb-3">
                            <label for="memberLoginId" class="form-label">아이디 <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="memberLoginId" name="memberLoginId"
                                       placeholder="영문, 숫자 조합 4-20자" required />
                            </div>
                            <div id="idError" class="error-message"></div>
                            <div id="idSuccess" class="success-message"></div>
                        </div>

                        <!-- 비밀번호 -->
                        <div class="mb-3">
                            <label for="memberPw" class="form-label">비밀번호 <span class="text-danger">*</span></label>
                            <div class="input-group input-group-merge">
                                <input type="password" id="memberPw" class="form-control" name="memberPw"
                                       placeholder="영문, 숫자, 특수문자 조합 8-20자" required />
                                <span class="input-group-text cursor-pointer" id="togglePw"><i class="bx bx-hide"></i></span>
                            </div>
                            <div id="pwError" class="error-message"></div>
                        </div>

                        <!-- 비밀번호 확인 -->
                        <div class="mb-3">
                            <label for="memberPwConfirm" class="form-label">비밀번호 확인 <span class="text-danger">*</span></label>
                            <div class="input-group input-group-merge">
                                <input type="password" id="memberPwConfirm" class="form-control"
                                       placeholder="비밀번호를 다시 입력하세요" required />
                                <span class="input-group-text cursor-pointer" id="togglePwConfirm"><i class="bx bx-hide"></i></span>
                            </div>
                            <div id="pwConfirmError" class="error-message"></div>
                        </div>

                        <!-- 이름 -->
                        <div class="mb-3">
                            <label for="memberName" class="form-label">이름 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="memberName" name="memberName"
                                   placeholder="이름을 입력하세요" required />
                            <div id="nameError" class="error-message"></div>
                        </div>

                        <!-- 전화번호 -->
                        <div class="mb-3">
                            <label for="memberPhone" class="form-label">전화번호 <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="memberPhone" name="memberPhone"
                                   placeholder="010-1234-5678" required />
                            <div id="phoneError" class="error-message"></div>
                        </div>

                        <!-- 이메일 -->
                        <div class="mb-3">
                            <label for="memberEmail" class="form-label">이메일 <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="memberEmail" name="memberEmail"
                                   placeholder="example@email.com" required />
                            <div id="emailError" class="error-message"></div>
                        </div>

                        <!-- 사업자번호 -->
                        <div class="mb-3">
                            <label for="businessNumber" class="form-label">사업자등록번호 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="businessNumber" name="businessNumber"
                                   placeholder="123-45-67890" required />
                            <div id="businessError" class="error-message"></div>
                        </div>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger">
                                    ${errorMessage}
                            </div>
                        </c:if>

                        <div class="mb-3">
                            <button class="btn btn-primary d-grid w-100" type="submit" id="submitBtn" disabled>회원가입</button>
                        </div>
                    </form>

                        <p class="text-center">
                            <span>이미 회원이신가요? </span>
                            <a href="/member/login">
                                <span>로그인하기</span>
                            </a>
                        </p>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('formRegistration');
        const submitBtn = document.getElementById('submitBtn');

        // 검증 상태를 추적하는 객체
        const validationState = {
            memberLoginId: false,
            memberPw: false,
            memberPwConfirm: false,
            memberName: false,
            memberPhone: false,
            memberEmail: false,
            businessNumber: false
        };

        // 아이디 검증 (영문, 숫자 조합 4-20자)
        const memberLoginId = document.getElementById('memberLoginId');
        const idError = document.getElementById('idError');
        const idSuccess = document.getElementById('idSuccess');

        memberLoginId.addEventListener('input', function() {
            const value = this.value.trim();
            const idRegex = /^[a-zA-Z0-9]{4,20}$/;

            if (value === '') {
                idError.textContent = '';
                idSuccess.textContent = '';
                validationState.memberLoginId = false;
            } else if (!idRegex.test(value)) {
                idError.textContent = '영문, 숫자 조합 4-20자로 입력해주세요.';
                idSuccess.textContent = '';
                validationState.memberLoginId = false;
            } else {
                idError.textContent = '';
                idSuccess.textContent = '사용 가능한 아이디입니다.';
                validationState.memberLoginId = true;
            }
            checkFormValid();
        });

        // 비밀번호 검증 (영문, 숫자, 특수문자 조합 8-20자)
        const memberPw = document.getElementById('memberPw');
        const pwError = document.getElementById('pwError');

        memberPw.addEventListener('input', function() {
            const value = this.value;
            // 영문, 숫자, 특수문자를 각각 포함하는지 체크
            const hasLetter = /[a-zA-Z]/.test(value);
            const hasNumber = /[0-9]/.test(value);
            const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(value);
            const validLength = value.length >= 8 && value.length <= 20;

            if (value === '') {
                pwError.textContent = '';
                validationState.memberPw = false;
            } else if (!validLength) {
                pwError.textContent = '비밀번호는 8-20자로 입력해주세요.';
                validationState.memberPw = false;
            } else if (!hasLetter || !hasNumber || !hasSpecial) {
                pwError.textContent = '영문, 숫자, 특수문자를 모두 포함해야 합니다.';
                validationState.memberPw = false;
            } else {
                pwError.textContent = '';
                validationState.memberPw = true;
            }

            // 비밀번호 확인 필드가 채워져 있다면 재검증
            if (memberPwConfirm.value !== '') {
                memberPwConfirm.dispatchEvent(new Event('input'));
            }
            checkFormValid();
        });

        // 비밀번호 확인 검증
        const memberPwConfirm = document.getElementById('memberPwConfirm');
        const pwConfirmError = document.getElementById('pwConfirmError');

        memberPwConfirm.addEventListener('input', function() {
            const value = this.value;

            if (value === '') {
                pwConfirmError.textContent = '';
                validationState.memberPwConfirm = false;
            } else if (value !== memberPw.value) {
                pwConfirmError.textContent = '비밀번호가 일치하지 않습니다.';
                validationState.memberPwConfirm = false;
            } else {
                pwConfirmError.textContent = '';
                validationState.memberPwConfirm = true;
            }
            checkFormValid();
        });

        // 이름 검증 (한글, 영문 2-20자)
        const memberName = document.getElementById('memberName');
        const nameError = document.getElementById('nameError');

        memberName.addEventListener('input', function() {
            const value = this.value.trim();
            const nameRegex = /^[가-힣a-zA-Z]{2,20}$/;

            if (value === '') {
                nameError.textContent = '';
                validationState.memberName = false;
            } else if (!nameRegex.test(value)) {
                nameError.textContent = '한글 또는 영문 2-20자로 입력해주세요.';
                validationState.memberName = false;
            } else {
                nameError.textContent = '';
                validationState.memberName = true;
            }
            checkFormValid();
        });

        // 전화번호 검증 (010-XXXX-XXXX 형식)
        const memberPhone = document.getElementById('memberPhone');
        const phoneError = document.getElementById('phoneError');

        memberPhone.addEventListener('input', function() {
            let value = this.value.replace(/[^0-9]/g, ''); // 숫자만 추출

            // 자동으로 하이픈 추가
            if (value.length > 3 && value.length <= 7) {
                value = value.slice(0, 3) + '-' + value.slice(3);
            } else if (value.length > 7) {
                value = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7, 11);
            }

            this.value = value;

            const phoneRegex = /^010-\d{4}-\d{4}$/;

            if (value === '') {
                phoneError.textContent = '';
                validationState.memberPhone = false;
            } else if (!phoneRegex.test(value)) {
                phoneError.textContent = '올바른 전화번호 형식이 아닙니다. (010-XXXX-XXXX)';
                validationState.memberPhone = false;
            } else {
                phoneError.textContent = '';
                validationState.memberPhone = true;
            }
            checkFormValid();
        });

        // 이메일 검증
        const memberEmail = document.getElementById('memberEmail');
        const emailError = document.getElementById('emailError');

        memberEmail.addEventListener('input', function() {
            const value = this.value.trim();
            const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

            if (value === '') {
                emailError.textContent = '';
                validationState.memberEmail = false;
            } else if (!emailRegex.test(value)) {
                emailError.textContent = '올바른 이메일 형식이 아닙니다.';
                validationState.memberEmail = false;
            } else {
                emailError.textContent = '';
                validationState.memberEmail = true;
            }
            checkFormValid();
        });

        // 사업자등록번호 검증 (10자리 숫자, 자동으로 하이픈 추가)
        const businessNumber = document.getElementById('businessNumber');
        const businessError = document.getElementById('businessError');

        businessNumber.addEventListener('input', function() {
            let value = this.value.replace(/[^0-9]/g, ''); // 숫자만 추출

            // 자동으로 하이픈 추가 (XXX-XX-XXXXX 형식)
            if (value.length > 3 && value.length <= 5) {
                value = value.slice(0, 3) + '-' + value.slice(3);
            } else if (value.length > 5) {
                value = value.slice(0, 3) + '-' + value.slice(3, 5) + '-' + value.slice(5, 10);
            }

            this.value = value;

            const businessRegex = /^\d{3}-\d{2}-\d{5}$/;

            if (value === '') {
                businessError.textContent = '';
                validationState.businessNumber = false;
            } else if (!businessRegex.test(value)) {
                businessError.textContent = '사업자등록번호는 10자리 숫자입니다. (XXX-XX-XXXXX)';
                validationState.businessNumber = false;
            } else {
                businessError.textContent = '';
                validationState.businessNumber = true;
            }
            checkFormValid();
        });

        // 비밀번호 표시/숨김 토글
        const togglePw = document.getElementById('togglePw');
        togglePw.addEventListener('click', function() {
            const type = memberPw.type === 'password' ? 'text' : 'password';
            memberPw.type = type;
            this.querySelector('i').classList.toggle('bx-hide');
            this.querySelector('i').classList.toggle('bx-show');
        });

        const togglePwConfirm = document.getElementById('togglePwConfirm');
        togglePwConfirm.addEventListener('click', function() {
            const type = memberPwConfirm.type === 'password' ? 'text' : 'password';
            memberPwConfirm.type = type;
            this.querySelector('i').classList.toggle('bx-hide');
            this.querySelector('i').classList.toggle('bx-show');
        });

        // 전체 폼 유효성 검사
        function checkFormValid() {
            const allValid = Object.values(validationState).every(valid => valid === true);
            submitBtn.disabled = !allValid;
        }

        // 폼 제출 시 최종 검증
        form.addEventListener('submit', function(e) {
            const allValid = Object.values(validationState).every(valid => valid === true);

            if (!allValid) {
                e.preventDefault();
                alert('모든 항목을 올바르게 입력해주세요.');
                return false;
            }

            // 사업자등록번호에서 하이픈 제거 후 다시 형식에 맞게 추가 (서버 전송용)
            const businessValue = businessNumber.value.replace(/[^0-9]/g, '');
            const formattedBusiness = businessValue.slice(0, 3) + '-' +
                businessValue.slice(3, 5) + '-' +
                businessValue.slice(5, 10);
            businessNumber.value = formattedBusiness;
        });
    });
</script>


<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/popper/popper.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/vendor/js/bootstrap.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

<script src="${pageContext.request.contextPath}/resources/assets/vendor/js/menu.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>

<script async defer src="https://buttons.github.io/buttons.js"></script>
</body>
</html>