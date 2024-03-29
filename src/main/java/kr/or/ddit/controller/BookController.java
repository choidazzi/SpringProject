package kr.or.ddit.controller;



import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import kr.or.ddit.service.BookService;
import kr.or.ddit.vo.BookVO;
import lombok.extern.slf4j.Slf4j;

import org.apache.commons.dbcp2.BasicDataSource;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;

/* Controller 어노테이션
 스프링 프레임워크에게 "이 클래스는 웹 브라우저의 요청(request)을 
 받아들이는 컨트롤러야"라고 알려 주는 것임. 
 스프링은 servlet-context.xml의 context:component-scan의 설정에 의해
 이 클래스를 자바빈 객체로 등록(메모리에 바인딩)
 */
@Slf4j
@Controller
public class BookController {

	// DI, IoC
	@Autowired
	BookService bookService;

	/*
	 * 요청URL : /create 요청파라미터 : 없음 요청방식 : get
	 */
	@RequestMapping(value = "/create", method = RequestMethod.GET)
	public ModelAndView create() {
		/*
		 * ModelAndView 1) Model : Contriller가 반환할 데이터(String, int, List, Map, VO...)를
		 * 담당 2) View : 화면을 담당(뷰(View : jsp)의 경로)
		 */
		ModelAndView mav = new ModelAndView();

		// forwarding : JSP를 처리, 컴파일하여 HTML로 만들어 리턴한다
		// prefix : /WEB-INF/views/
		mav.setViewName("book/create");
		// suffix : .jsp
		// 조립되면 : /WEB-INF/views/book/create.jsp

		return mav;
	}

	/*
	 * 요청URL : /create 요청파라미터 : {title=수인이의 모험, category="소설",price=10000} 요청방식 :
	 * post
	 * 
	 * bookVO : BookVO [bookId=0, title=22, category=2, price=2, content=null,
	 * insertDate=null]
	 */
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public ModelAndView createPost(HttpServletRequest request, ModelAndView mav, BookVO bookVO) {
		String title = request.getParameter("title");
		String category = request.getParameter("category");
		String price = request.getParameter("price");

		// log.info("title : " + title + ", category : " + category + ", price : " +
		// price);

		log.info("bookVO : " + bookVO);

		int result = this.bookService.insert(bookVO);
		log.info("result : " + result);

		// forwarding
		mav.setViewName("book/create");

		return mav;
	}

	// 책 상세보기
	// 요청URI : /detail?bookId=1
	// 요청URL : /detail
	// 요청파라미터 : bookId=1
	// BookVO [bookId=1, title=null, category=null, price=0, content=null,
	// insertDate=null]
	@RequestMapping(value = "/detail", method = RequestMethod.GET)
	public ModelAndView detail(BookVO bookVO, ModelAndView mav) {
		log.info("detail->bookVO(전) : " + bookVO);

		bookVO = this.bookService.detail(bookVO);

		log.info("detail->bookVO(후) : " + bookVO);
		
		
		mav.addObject("data", bookVO);
		//name="prefix" value="/WEB-INF/views/"
		mav.setViewName("book/detail");
		//name="suffix" value=".jsp"
		
		return mav;
	}
	
	//도서 목록
	/*
	요청URI : /list?keyword=수인
	요청URI : /list
	요청파라미터 : keyword=수인
	요청방식 : get
	
	VO에는 골뱅이ModelAttribute
	단일매개변수에는 골뱅이RequestParam
	
	골뱅이RequestParam
	 - value : 파라미터의 명
	 - required : true(필수 -> /list(x))/false(선택 -> /list(o))
	 - defaultValue : /list 경우 기본값을 설정
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ModelAndView list(ModelAndView mav, 
			@RequestParam(value = "keyword", required = false, defaultValue="") String keyword) {
		
		log.info("keyword : " + keyword);
		
		List<BookVO> list = bookService.list(keyword);
		
		log.info("list->list : " + list);
		
		//ModelAndView의 Model(데이터 파트)
		mav.addObject("list", list);
		//ModelAndView의 View(뷰(jsp) 파트)
		//forwarding
		mav.setViewName("book/list");
		
		return mav;
	}
	
	
	//요청 URL : /updatePost
	//요청파라미터
	// BookVO [bookId=1, title=null, category=null, price=0, content=null,
	// insertDate=null]
	//요청방식 : post
	@RequestMapping(value = "/updatePost", method = RequestMethod.POST)
	public ModelAndView updatePost(@ModelAttribute BookVO bookVO, ModelAndView mav) {
		log.info("bookVO : " + bookVO);
		
		int result = this.bookService.updatePost(bookVO);
		log.info("result : " + result);
		
		//업데이트 성공 시 -> 책 상세페이지(detail.jsp)로 이동
		// /detail?bookId=1
		if(result>0) {
			//redirect : URI를 재요청
			mav.setViewName("redirect:/detail?bookId=" + bookVO.getBookId());
		}else {
			//업데이트 실패 시 -> 색 목록페이지(list.jsp)로 이동
			// /list			
			mav.setViewName("redirect:/list");
		}
		
		return mav;
	}
	
	//요청URI : /deletePost
	//요청파라미터 : [bookId=1]
	//요청방식:POST
	@RequestMapping(value = "/deletePost", method = RequestMethod.POST)
	public ModelAndView deletePost(int bookId, ModelAndView mav) {
		log.info("bookId : " + bookId);
		
		int result = this.bookService.deletePost(bookId);
		log.info("result : " + result);
		
		if(result > 0) {
			mav.setViewName("redirect:/list");
		} else {
			mav.setViewName("redirect:/detail?bookId=" + bookId );
		}
		
		return mav;
	}

}




