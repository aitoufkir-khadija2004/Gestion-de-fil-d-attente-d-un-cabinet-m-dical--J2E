package dao;
public class DAOFactory {
        private static DAOFactory instance;
    
    private DAOFactory() {
    }
    
    public static DAOFactory getInstance() {
        if (instance == null) {
            synchronized (DAOFactory.class) {
                if (instance == null) {
                    instance = new DAOFactory();
                }
            }
        }
        return instance;
    }
        public UserDAOImpl getUserDAO() {
        return new UserDAOImpl();
    }
    
    public SpecialiteDAOImpl getSpecialiteDAO() {
        return new SpecialiteDAOImpl();
    }
    
    public CreneauDAOImpl getCreneauDAO() {
        return new CreneauDAOImpl();
    }
    
    public TicketDAOImpl getTicketDAO() {
        return new TicketDAOImpl();
    }
    
    public ConsultationDAOImpl getConsultationDAO() {
        return new ConsultationDAOImpl();
    }
    
    public NotificationDAOImpl getNotificationDAO() {
        return new NotificationDAOImpl();
    }
}